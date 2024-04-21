import 'package:flutter_platform_game/common/globals.dart';
import 'package:flutter_platform_game/utils/hitbox.dart';

class Bullet extends HitBox {

  bool visible = true;

  Bullet({
    super.x = 0,
    super.y = 0,
    super.width = 16,
    super.height = 16,
    super.dir,
  }) {
    velocity = Vector.all(4.0);
    sprites = Globals.fireBall;
  }
  
  void move() {
    var v = dir == Dir.left ? -1 : 1;
    x += velocity.x * v;

    if (x % 10 == 0) {
      var pos = x.toInt() % sprites.length;
      sprite = sprites[pos];
    }
  }
  
}
