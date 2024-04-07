import 'package:flutter_platform_game/globals.dart';
import 'package:flutter_platform_game/hitbox.dart';

enum PlatformType { ground, block, pipe, wall }

class Platforms extends HitBox {

  PlatformType type;
  bool visible = true;

  Platforms({
    super.x = 0,
    super.y = 0,
    super.width = 48.0,
    super.height = 48.0,
    required this.type,
  }) {
    _init();
  }

  void _init() {
    switch (type) {
      case PlatformType.ground: 
        sprite = Globals.ground; 
        break;
      case PlatformType.wall:
        sprite = Globals.wall; 
        break;
      case PlatformType.block: 
        sprite = Globals.block; 
        break;
      case PlatformType.pipe: 
        sprite = Globals.pipe; 
        break;
      default:
        break;
    }
  }
  
}
