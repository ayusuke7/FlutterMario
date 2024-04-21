import 'package:flutter_platform_game/common/globals.dart';
import 'package:flutter_platform_game/utils/hitbox.dart';
import 'package:flutter_platform_game/actors/platforms.dart';

enum PowerUpType { star, coin, flower, mushroom, steal }

class PowerUp extends HitBox {

  bool visible = true;
  PowerUpType type;

  PowerUp({
    super.x = 0,
    super.y = 0,
    super.width = 32,
    super.height = 32,
    required this.type
  }) {
    _init();
  }

  void _init() {
    /* set velocity */
    velocity = Vector.all(1.0);

    /* set sprites */
    switch (type) {
      case PowerUpType.mushroom:
        sprite = Globals.mushroom;
        break;
      case PowerUpType.flower:
        sprite = Globals.flower;
        break;
      case PowerUpType.coin:
        sprite = Globals.coin;
        break;
      case PowerUpType.star:
        sprite = Globals.star;
        break;
      case PowerUpType.steal:
        sprite = Globals.steal;
        break;
      default:
        break;
    }
  }

  void update(int time) {
    if (type == PowerUpType.coin && time % 30 == 0) {
      dir = dir == Dir.left ? Dir.right : Dir.left;
    }

    if (type == PowerUpType.mushroom) { 
      _move();
    }
  }

  void _move() {
    /* apply gravity */
    y += velocity.y;
    velocity.y += Globals.gravity;

    /* side moviment */
    var v = dir == Dir.left ? -1 : 1;    
    x += velocity.x * v;
    
  }

  void checkColisionWithPlatforms(List<Platforms> platforms) {
    if (type != PowerUpType.mushroom) return;

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
  
  factory PowerUp.copy(PowerUp powerup) {
    return PowerUp(
      x: powerup.x,
      y: powerup.y,
      width: powerup.width,
      height: powerup.height,
      type: powerup.type,
    );
  }
}
