import 'package:flutter/services.dart';
import 'package:flutter_platform_game/actors/enemy.dart';
import 'package:flutter_platform_game/common/globals.dart';
import 'package:flutter_platform_game/utils/hitbox.dart';
import 'package:flutter_platform_game/actors/platforms.dart';
import 'package:flutter_platform_game/actors/powerup.dart';

class LevelData {
  Size size;
  Offset scrollOffset;
  List<HitBox> objects;
  Color backgroundColor;

  LevelData({
    required this.size,
    required this.scrollOffset,
    required this.backgroundColor,
    required this.objects,
  });

  factory LevelData.copy(LevelData level) {
    return LevelData(
      size: level.size, 
      scrollOffset: level.scrollOffset, 
      backgroundColor: level.backgroundColor, 
      objects: level.objects.map((o) {
        if (o is Platforms) {
          return Platforms.copy(o);
        } else
        if (o is Enemy) {
          return Enemy.copy(o);
        } else
        if (o is PowerUp) {
          return PowerUp.copy(o);
        }
        
        return o;
      }).toList(),
    );
  }
}

final levelOne = LevelData(
  size: const Size(2400, 600), 
  scrollOffset: const Offset(1640.0, 0.0),
  backgroundColor: const Color.fromRGBO(100, 181, 246, 1),
  objects: [

    /* Blocks begin level  */
    Platforms(
      x: 250, 
      y: 300, 
      width: Globals.pixelSize * 3,
      type: PlatformType.block,
    ),
    Platforms(
      y: 300, 
      x: 296 + Globals.pixelSize * 2, 
      type: PlatformType.question,
      powerup: PowerUp(
        width: 48,
        height: 48,
        type: PowerUpType.mushroom
      )
    ),
    
    /* Platform final level */
    Platforms(
      y: 270, 
      x: 1600 - Globals.pixelSize * 3, 
      width: Globals.pixelSize * 3,
      type: PlatformType.block,
    ),
    Platforms(
      y: 100, 
      x: 1600 - Globals.pixelSize * 2, 
      type: PlatformType.question,
      powerup: PowerUp(type: PowerUpType.flower)
    ),
    
    /* pipes */
    Platforms(
      x: 500, 
      y: 600 - Globals.pixelSize * 3,
      height: Globals.pixelSize * 2,
      width: Globals.pixelSize * 2,
      type: PlatformType.pipe,
    ),
    Platforms(
      x: 1400, 
      y: 600 - Globals.pixelSize * 3,
      height: Globals.pixelSize * 2,
      width: Globals.pixelSize * 2,
      type: PlatformType.pipe,
    ),
    
    /* ground */
    Platforms(
      y: 600 - Globals.pixelSize, 
      width: 1600, 
      type: PlatformType.ground,
    ),
    Platforms(
      y: 600 - Globals.pixelSize, 
      x: 1600 + 200, 
      width: (2400 - 1600) - 200, 
      type: PlatformType.ground,
    ),
    
    /* enemys */
    Enemy(
      x: 250,
      width: 42,
      height: 64,
      type: EnemyType.turtle,
      distance: Distance(
        x: 0,
        width: 1600,
      )
    ),
    Enemy(
      x: 1600 / 2,
      type: EnemyType.spike,
      distance: Distance(
        x: 0,
        width: 1000,
      )
    ),
    
    /* powerUps */
    PowerUp(
      x: 280, 
      y: 100,
      width: 22,
      height: 40,
      type: PowerUpType.coin
    ),
    PowerUp(
      x: 330, 
      y: 100,
      width: 22,
      height: 40,
      type: PowerUpType.coin
    ),
    PowerUp(
      x: 380, 
      y: 100,
      width: 22,
      height: 40,
      type: PowerUpType.coin
    ),
    PowerUp(
      x: 2359, 
      y: 600 - Globals.pixelSize * 2,
      width: 48,
      height: 48,
      type: PowerUpType.steal
    ),
    
  ]
);

final levelTwo = LevelData(
  size: const Size(800, 600), 
  scrollOffset: const Offset(200.0, 0.0),
  backgroundColor: const Color.fromARGB(255, 19, 77, 116),
  objects: [
    /* ground */
    Platforms(
      y: 600 - Globals.pixelSize, 
      width: 800, 
      type: PlatformType.ground,
    ),
  ]
);