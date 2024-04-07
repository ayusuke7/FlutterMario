import 'package:flutter/material.dart';
import 'package:flutter_platform_game/bullet.dart';
import 'package:flutter_platform_game/enemy.dart';
import 'package:flutter_platform_game/globals.dart';
import 'package:flutter_platform_game/hitbox.dart';
import 'package:flutter_platform_game/keys_map.dart';
import 'package:flutter_platform_game/platforms.dart';
import 'package:flutter_platform_game/powerup.dart';

enum Status { walking, running, jumping, firing, idle, die }

class Player extends HitBox {

  Status status = Status.idle;
  KeyMap keys = KeyMap();

  bool grounded = false;
  bool blocked = false;
  bool power = false;

  int life = 10;

  double speed = 4.0;
  List<Bullet> bullets = [];

  Player({
    super.x = 0,
    super.y = 0,
    super.width = 42,
    super.height = 64,
  });

  bool get die => life == 0;

  void update(int time, Size screen, double offset, double maxOffset) {
    x += velocity.x;
    y += velocity.y;

    /* apply gravity */
    velocity.y += Globals.gravity;
    
    /* check die over screen size */
    if (top > screen.height) {
      life = 0;
    }
    
    _move(screen, offset, maxOffset);
    _updateSprite(time);
    _updateBullets(screen);

  }

  void _move(Size screen, double offset, double maxOffset) {
    if (
      (keys.right && right < screen.width / 2) ||
      (keys.right && right < screen.width && offset == maxOffset)
    ) {
      velocity.x = speed;
      status = Status.running;
    } else 
    if (
      (keys.left && left > 100) ||
      (keys.left && left > 0 && offset == 0)
    ) {
      velocity.x = -speed;
      status = Status.running;
    } else {
      velocity.x = 0;
      status = Status.idle;
    }
  }

  void _updateSprite(int time) {
    // tick 100 ms == 1s
    if (time % 20 != 0) return;

    /* sprite update per 1/2 second */
    var second = time ~/ 20;
    if (status == Status.running) {
      var pos = second % Globals.marioRun.length;
      sprite = Globals.marioRun[pos];
    } else
    if (status == Status.jumping) {
      sprite = Globals.marioJump;
    } else 
    if (status == Status.firing) {
      sprite = Globals.marioJump;
    } else 
    if (status == Status.die) {
      sprite = Globals.marioDie;
    } else {
      sprite = Globals.marioIdle;
    }
    
  }

  void _updateBullets(Size screen) {
    /* move bullets */
    for (var bullet in bullets) {
      bullet.move();
    }

    /* remove bullets */
    bullets.removeWhere((b) {
      return !b.visible || b.right < 0 || b.left > screen.width;
    });
  }

  void jump([bool enemy = false]) {
    if (enemy || (keys.up && grounded)) {
      velocity.y = -6.0;
      grounded = false;
    }
  }
  
  void jumpDamage() {
    velocity.y = -Globals.gravity;
    velocity.x = speed * 4 * (dir == Dir.left ? 1 : -1);
  }

  void fire() {
    if (power) {
      var bullet = Bullet(
        dir: dir,
        x: x,
        y: y,
      );
      bullets.add(bullet);
    }
  }

  void damage([bool full = false]) {
    if (full) {
      life = 0;
    } else {
      life -= 5;
    }
  }

  void checkColisionPlatforms(List<Platforms> platforms) {
    for (var platform in platforms) {
      if (collideWith(platform)) {
        var colision = collideWithSide(platform);

        if (colision.left || colision.right) {
          velocity.x = 0;
          blocked = true;
        }

        if (colision.top || colision.bottom) {
          velocity.y = 0;
          
          if (colision.top) {
            grounded = true;
          } else
          if (colision.bottom && platform.type == PlatformType.wall) {
            platform.visible = false;
          }
        }
      }
    }
  }

  void checkColisionBulletEnemy(List<Enemy> enemys) {
    for (var b in bullets) { 
      var i = enemys.indexWhere((e) => e.collideWith(b));
      if (i > -1) {
        enemys[i].damage(power);
        //enemys[i].damage();
        b.visible = false;
      }
    }
  }

  void checkColisionPowerUps(List<PowerUp> powerups) {
    var i = powerups.indexWhere((p) => collideWith(p));
    if (i > -1) {
      powerups[i].visible = false;
      power = true;
    }
  }

}