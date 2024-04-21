import 'package:flutter/material.dart';
import 'package:flutter_platform_game/actors/bullet.dart';
import 'package:flutter_platform_game/actors/enemy.dart';
import 'package:flutter_platform_game/common/globals.dart';
import 'package:flutter_platform_game/utils/hitbox.dart';
import 'package:flutter_platform_game/utils/keys_map.dart';
import 'package:flutter_platform_game/actors/platforms.dart';
import 'package:flutter_platform_game/actors/powerup.dart';

enum Status { walking, running, jumping, firing, idle, die }

class Player extends HitBox {

  Status status = Status.idle;
  KeyMap keys = KeyMap();

  bool grounded = false;
  bool blocked = false;
  bool power = false;

  int coins = 0;
  int life = 1;

  double speed = 4.0;
  List<Bullet> bullets = [];

  Player({
    super.x = 0,
    super.y = 0,
    super.width = 32,
    super.height = 42,
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
    
    _updateSprite(time);
    _updateBullets(screen);
    _move(screen, offset, maxOffset);

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
      
      if (!keys.right && !keys.left) {
        status = Status.idle;
      }
    }
  }

  void _updateSprite(int time) {
   
    // tick 100 ms == 1s
    if (time % 10 != 0) return;

    /* sprite update per 1/2 second */
    var second = time ~/ 10;

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

  void _updateSize() {
    if (life > 1) {
      width = 42;
      height = 64;
      y = y - 64;
    } else {
      width = 32;
      height = 42;
    }
  }

  PowerUp? _spawPowerUp(Platforms block) {
    block.updateSprite(PlatformType.blockOff);
    
    if (block.powerup != null) {
      var powerup = block.powerup!;
      powerup.x = block.x;
      powerup.y = block.y - block.height;
    }

    return block.powerup;
  } 

  void jump([bool enemy = false]) {
    if (enemy || (keys.up && grounded)) {
      velocity.y = -6.5;
      grounded = false;
      status = Status.jumping;
    }
  }
  
  void jumpDamage() {
    velocity.y = -Globals.gravity;
    velocity.x = speed * 4 * (dir == Dir.left ? 1 : -1);
  }

  void fire() {
    if (power) {
      status = Status.firing;
      bullets.add(Bullet(
        dir: dir,
        x: x,
        y: y,
      ));
    } 
  }

  void damage() {
    life -= 1;
    _updateSize();
  }

  void checkColisionPlatforms(List<Platforms> platforms, {
    void Function(PowerUp powerup)? onPowerUp,
  }) {
    for (var platform in platforms) {
      if (collideWith(platform)) {
        var colision = collideWithSide(platform);
        if (colision.left || colision.right) {
          velocity.x = 0;
          blocked = true;
        } else
        if (colision.top) {
          velocity.y = 0;
          grounded = true;
        } else
        if (colision.bottom) {
          velocity.y = 0;

          if (platform.type == PlatformType.wall) {
            platform.visible = false;
          } else
          if (platform.type == PlatformType.question && onPowerUp != null) {
            var powerup = _spawPowerUp(platform);
            if (powerup != null) onPowerUp(powerup);
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
        b.visible = false;
      }
    }
  }

  void checkColisionPowerUps(List<PowerUp> powerups, {
    void Function(PowerUp powerup)? onPowerUp 
  }) {
    var i = powerups.indexWhere((p) => collideWith(p));
    if (i > -1) {
      powerups[i].visible = false;
      
      if (powerups[i].type == PowerUpType.mushroom) {
        life = 2;
        _updateSize();
      } else
      if (powerups[i].type == PowerUpType.flower) {
        life = 2;
        power = true;
        _updateSize();
      } else
      if (powerups[i].type == PowerUpType.coin) {
        coins++;
      } 

      if (onPowerUp != null) {
        onPowerUp(powerups[i]);
      }
    }
  }

  factory Player.copy(Player player) {
    return Player(
      x: player.x,
      y: player.y,
      width: player.width,
      height: player.height,
    );
  }

}