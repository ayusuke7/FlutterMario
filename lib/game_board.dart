import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_game/actors/enemy.dart';
import 'package:flutter_platform_game/common/globals.dart';
import 'package:flutter_platform_game/utils/hitbox.dart';
import 'package:flutter_platform_game/utils/keys_map.dart';
import 'package:flutter_platform_game/common/levels.dart';
import 'package:flutter_platform_game/actors/platforms.dart';
import 'package:flutter_platform_game/actors/player.dart';
import 'package:flutter_platform_game/actors/powerup.dart';
import 'package:flutter_platform_game/components/sprite_component.dart';

class GameBoard extends StatefulWidget {
  final LevelData level;
  
  const GameBoard({ 
    super.key,
    required this.level,
  });

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
    
  final fps = const Duration(milliseconds: 10);
  final screenSize = Globals.screenSize;
  final pixelSize = Globals.pixelSize;
  final player = Player(x: 100, y: 100);

  List<HitBox> objects = [];
  double scrollOffset = 0.0;
  int seconds = 400;

  Timer? timer;

  double get maxScrollOffset => widget.level.scrollOffset.dx;
  List<Platforms> get platforms => objects.whereType<Platforms>().toList();
  List<PowerUp> get powerups => objects.whereType<PowerUp>().toList();
  List<Enemy> get enemys => objects.whereType<Enemy>().toList();

  void setObjects() {
    objects = List.from(widget.level.objects);
  }

  void removeObjects() {
    /* Remove Enemys / PowerUps / Platforms */
    objects.removeWhere((o) {
      if (o is Enemy) {
        return o.die;
      } else 
      if (o is Platforms) {
        return !o.visible;
      } else 
      if (o is PowerUp) {
        return !o.visible;
      }

      return false;
    });
  }

  void moveCamera() {
    if (player.velocity.x == 0) {
      if (!player.blocked && player.keys.right && scrollOffset < maxScrollOffset) {
        scrollOffset += player.speed;
        for (var o in objects) { 
          o.x -= player.speed;
        }
      } else 
      if (!player.blocked && player.keys.left && scrollOffset > 0){
        scrollOffset -= player.speed;
        for (var o in objects) { 
          o.x += player.speed;
        }
      } else {
        player.blocked = false;
      }
    }
  }

  void updateTime(int time){
    if (time % 100 == 0) {
      seconds--;
    }
  }

  void update() {
    timer = Timer.periodic(fps, (t) {

      /* update three widgets */
      setState(() { 

        updateTime(t.tick);
        moveCamera();

        /* Player */
        player.update(t.tick, screenSize, scrollOffset, maxScrollOffset);
        player.checkColisionBulletEnemy(enemys);
        player.checkColisionPowerUps(powerups, 
          onPowerUp: (power){
            if (power.type == PowerUpType.steal) {
              t.cancel();
              exit();
            }
          }
        );
        player.checkColisionPlatforms(platforms,
          onPowerUp: (power){
            objects.add(power);
          });

        /* Enemys */
        for (var enemy in enemys) {
          enemy.update(t.tick, widget.level.size);
          enemy.checkColisionWithPlayer(player);
          enemy.checkColisionWithPlatforms(platforms);
        }

        /* PowerUps */
        for (var power in powerups) {
          power.update(t.tick);
          power.checkColisionWithPlatforms(platforms);
        }
        
        removeObjects();
        
      });

      /* check player die */
      if (player.die) {
        t.cancel(); 
        exit();
      }

    });
  }

  void exit() async {
    Timer(const Duration(seconds: 1), () { 
      Navigator.pop(context, player.die);
    });
  }

  @override
  void initState() {
    super.initState();
    setObjects();
    update();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Focus(
        autofocus: true,
        onKeyEvent: keyListenner,
        child: Center(
          child: Container(
            width: screenSize.width,
            height: screenSize.height,
            color: widget.level.backgroundColor,
            child: Stack(
              children: [

                /* HUD */
                Positioned(
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    width: screenSize.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        hudText("MARIO\n00000"),
                        hudText("COIN x ${"${player.coins}".padLeft(3, "0")}"),
                        hudText("WORLD\n1 - 1"),
                        hudText("TIME\n$seconds"),
                      ]
                    ),
                  )
                ),

                /* Player */
                AnimatedPositioned(
                  duration: fps,
                  top: player.top,
                  left: player.left,
                  child: SpriteComponent(
                    fit: BoxFit.fill,
                    asset: player.sprite,
                    flipX: player.dir == Dir.left,
                    imgSize: Size(player.width, player.height),
                  )
                ),

                /* Objects */
                for (var obj in [
                  ...objects,
                  ...player.bullets
                ])
                  AnimatedPositioned(
                    top: obj.top,
                    left: obj.left,
                    duration: fps,
                    child: SpriteComponent(
                      asset: obj.sprite,
                      flipX: obj.dir == Dir.left,
                      repeat: ImageRepeat.repeat,
                      imgSize: Size(obj.width, obj.height),
                    )
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget hudText(String text) {
    return Text(text, 
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
        height: 1.0
      )
    );
  }

  KeyEventResult keyListenner(FocusNode node, KeyEvent event) {
    var pressed = HardwareKeyboard.instance.isLogicalKeyPressed(event.logicalKey);

    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      player.keys.up = pressed;
      player.jump();
    } else
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      player.keys.left = pressed;
      player.dir = Dir.left;
    } else
    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      player.keys.right = pressed;
      player.dir = Dir.right;
    } else
    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      player.keys.down = pressed;
    } else
    if (event.logicalKey == LogicalKeyboardKey.space) {
      if (pressed) player.fire();
    } else {
      player.keys = KeyMap();
    }
    
    return KeyEventResult.handled;
  }
}