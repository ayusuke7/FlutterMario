import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_game/enemy.dart';
import 'package:flutter_platform_game/globals.dart';
import 'package:flutter_platform_game/hitbox.dart';
import 'package:flutter_platform_game/keys_map.dart';
import 'package:flutter_platform_game/levels.dart';
import 'package:flutter_platform_game/platforms.dart';
import 'package:flutter_platform_game/player.dart';
import 'package:flutter_platform_game/powerup.dart';
import 'package:flutter_platform_game/components/progress_bar.dart';
import 'package:flutter_platform_game/components/sprite_component.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
    
  final fps = const Duration(milliseconds: 10);
  final screenSize = Globals.screenSize;
  final pixelSize = Globals.pixelSize;
  
  Player player = Player(x: 100, y: 100);
  LevelData level = LevelData.copy(levelOne);

  double scrollOffset = 0.0;
  Timer? timer;

  List<Platforms> get platforms => level.objects.whereType<Platforms>().toList();
  List<PowerUp> get powerups => level.objects.whereType<PowerUp>().toList();
  List<Enemy> get enemys => level.objects.whereType<Enemy>().toList();

  void moveCamera() {
    if (player.velocity.x == 0) {
      if (!player.blocked && player.keys.right && scrollOffset < level.scrollOffset.dx) {
        scrollOffset += player.speed;
        for (var o in level.objects) { 
          o.x -= player.speed;
        }
      } else 
      if (!player.blocked && player.keys.left && scrollOffset > 0){
        scrollOffset -= player.speed;
        for (var o in level.objects) { 
          o.x += player.speed;
        }
      } else {
        player.blocked = false;
      }
    }
  }

  void update() {
    timer = Timer.periodic(fps, (t) {

      if (player.die) { t.cancel(); }

      /* update three widgets */
      setState(() {
        
        /* follow player */
        moveCamera();

        /* Player */
        player.update(t.tick, screenSize, scrollOffset, level.scrollOffset.dx);
        player.checkColisionPlatforms(platforms);
        player.checkColisionBulletEnemy(enemys);
        player.checkColisionPowerUps(powerups);

        /* Enemys */
        for (var enemy in enemys) {      
          enemy.update(t.tick, level.size);
          enemy.checkColisionWithPlayer(player);
          enemy.checkColisionWithPlatforms(platforms);
        }

        /* Remove Enemys / PowerUps / Platforms */
        level.objects.removeWhere((o) {
          if (o is Enemy) {
            return o.die;
          } else if (o is Platforms) {
            return !o.visible;
          } else if (o is PowerUp) {
            return !o.visible;
          }

          return false;
        });
        
      });
    });
  }

  void reset() {
    scrollOffset = 0.0;
    player = Player(x: 100, y: 100);
    level = LevelData.copy(levelOne);
  }

  @override
  void initState() {
    super.initState();
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
            color: level.backgroundColor,
            child: Stack(
              children: [

                Positioned(
                  top: 10,
                  left: 10,
                  child: ProgressBar(
                    label: "Player",
                    percentage: (player.life * 10) / 100,
                  )
                ),

                /* Objects */
                for (var obj in level.objects)
                  AnimatedPositioned(
                    top: obj.top,
                    left: obj.left,
                    duration: fps,
                    child: SpriteComponent(
                      debug: true,
                      asset: obj.sprite,
                      flipX: obj.dir == Dir.right,
                      repeat: ImageRepeat.repeat,
                      imgSize: Size(obj.width, obj.height),
                    )
                  ),
                
                /* Player */
                AnimatedPositioned(
                  duration: fps,
                  top: player.top,
                  left: player.left,
                  child: SpriteComponent(
                    debug: true,
                    fit: BoxFit.fill,
                    asset: player.sprite,
                    flipX: player.dir == Dir.left,
                    imgSize: Size(player.width, player.height),
                  )
                ),
              ],
            ),
          ),
        ),
      ),
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
    if (event.logicalKey == LogicalKeyboardKey.space) {
      if (pressed) player.fire();
    } else {
      player.keys = KeyMap();
    }
    
    return KeyEventResult.handled;
  }
}