import 'package:flutter_platform_game/common/globals.dart';
import 'package:flutter_platform_game/utils/hitbox.dart';
import 'package:flutter_platform_game/actors/powerup.dart';

enum PlatformType { ground, block, blockOff, pipe, wall, question }

class Platforms extends HitBox {

  bool visible = true;
  
  PlatformType type;
  PowerUp? powerup;

  Platforms({
    super.x = 0,
    super.y = 0,
    super.width = 48.0,
    super.height = 48.0,
    this.powerup,
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
      case PlatformType.question: 
        sprite = Globals.question; 
        break;
      case PlatformType.pipe: 
        sprite = Globals.pipe; 
      case PlatformType.blockOff: 
        sprite = Globals.blockOff; 
        break;
      default:
        break;
    }
  }
  
  void updateSprite(PlatformType newType){
    type = newType;
    _init();
  }

  factory Platforms.copy(Platforms platform) {
    return Platforms(
      x: platform.x,
      y: platform.y,
      width: platform.width,
      height: platform.height,
      powerup: platform.powerup,
      type: platform.type,
    );
  }

}
