import 'package:flutter/material.dart';
import 'package:flutter_platform_game/globals.dart';
import 'package:flutter_platform_game/hitbox.dart';
import 'package:flutter_platform_game/platforms.dart';
import 'package:flutter_platform_game/player.dart';

enum EnemyType { turtle, spike } 

class Enemy extends HitBox {

  Distance distance;
  EnemyType type;
  
  int life = 2;

  Enemy({
    super.x = 0,
    super.y = 0,
    super.width = Globals.pixelSize,
    super.height = Globals.pixelSize,
    required this.type,
    required this.distance,
  }) {
    _init();
  }

  bool get die => life == 0;

  void _init() {
    
    /* Random start direction */
    var t = [Dir.left, Dir.right];
    t.shuffle();
    dir = t.first;

    /* set velocity */
    velocity = Vector.all(1.0);

    /* set spritesheet */
    switch(type) {
        case EnemyType.turtle:
          sprites = Globals.turtleRun;
          break;
        case EnemyType.spike:
          sprites = Globals.spikeRun;
          break;
        default: 
          break;
      }
  }

  void update(int time, Size screen) {
    y += velocity.y;

    /* apply gravity */
    velocity.y += Globals.gravity;

    /* check die over screen size */
    if (top > screen.height) {
      life = 0;
    }
    
    _move();
    _updateSprites(time);
  }

  void _move() {
    var v = dir == Dir.left ? -1 : 1;    
    x += velocity.x * v;
    if (dir == Dir.right && right >= distance.x + distance.width) {
      dir = Dir.left;
    } else
    if (dir == Dir.left && left <= distance.x) {
      dir = Dir.right;
    }
  }

  void _updateSprites(int time) {
    if (sprites.isNotEmpty && x % 20 == 0) {
      var second = time ~/ 20;
      var pos = second % sprites.length;
      sprite = sprites[pos];
    }
  }

  void damage([bool full = false]) {
    if (full) { 
      life = 0;
    } else {
      life -= 1;
    }
    
  }

  void changeDir() {
    dir = dir == Dir.left ? Dir.right : Dir.left;
  }

  void checkColisionWithPlayer(Player player) {
    if (collideWith(player)) {
      var colision = collideWithSide(player);

      /* enemy full damage on jump top */
      if (colision.bottom) {
        player.jump(true);
        damage(true);
      } else {
        /* player damage on colision left or right */
        player.damage();    
        if (colision.left) {
          changeDir();
        } else
        if (colision.right) {
          changeDir();
          if (player.left > 0) {
            player.jumpDamage();
          }
        }
      }

    }
  }

  void checkColisionWithPlatforms(List<Platforms> platforms) {
    for (var platform in platforms) {
      if (collideWith(platform)) {
        var colision = collideWithSide(platform);

        if (colision.top) {
          velocity.y = 0;
        }

        if (colision.left || colision.right) {
          changeDir();
        }
      }
    }
  }

}

class Distance  {

  double x;
  double width;

  Distance({
    required this.x,
    required this.width    
  });
}