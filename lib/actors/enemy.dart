import 'package:flutter/material.dart';
import 'package:flutter_platform_game/common/globals.dart';
import 'package:flutter_platform_game/utils/hitbox.dart';
import 'package:flutter_platform_game/actors/platforms.dart';
import 'package:flutter_platform_game/actors/player.dart';

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
        sprite = Globals.turtleRun.first;
        break;
      case EnemyType.spike:
        sprites = Globals.spikeRun;
        sprite = Globals.spikeRun.first;
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
    if (
      (dir == Dir.right && right >= distance.x + distance.width) ||
      (dir == Dir.left && left <= distance.x)
    ) {
      changeDir();
    }
  }

  void _updateSprites(int time) {
    if (sprites.isNotEmpty && time % 20 == 0) {
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
        player.jumpDamage();
        changeDir();
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

  factory Enemy.copy(Enemy enemy) {
    return Enemy(
      x: enemy.x,
      y: enemy.y,
      width: enemy.width,
      height: enemy.height,
      type: enemy.type,
      distance: enemy.distance,
    );
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