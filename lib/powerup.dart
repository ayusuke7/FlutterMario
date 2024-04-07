import 'package:flutter_platform_game/globals.dart';
import 'package:flutter_platform_game/hitbox.dart';

enum PowerUpType { star, coin }

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
    switch (type) {
      case PowerUpType.coin:
        sprite = Globals.coin;
        break;
      case PowerUpType.star:
        sprite = Globals.star;
        break;
      default:
        break;
    }
  }
  
}
