import 'dart:ui';

import 'package:flutter_platform_game/enemy.dart';
import 'package:flutter_platform_game/globals.dart';
import 'package:flutter_platform_game/hitbox.dart';
import 'package:flutter_platform_game/platforms.dart';
import 'package:flutter_platform_game/powerup.dart';

class LevelData {
  Size size;
  Offset scrollOffset;
  List<HitBox> objects;
  Color backgroundColor;

  LevelData({
    required this.size,
    required this.scrollOffset,
    required this.objects,
    required this.backgroundColor
  });

  factory LevelData.copy(LevelData level) => LevelData(
    size: level.size,
    scrollOffset: level.scrollOffset,
    objects: level.objects,
    backgroundColor: level.backgroundColor
  );
}

LevelData levelOne = LevelData(
  size: const Size(1600, 600), 
  scrollOffset: const Offset(880.0, 0.0),
  backgroundColor: const Color.fromRGBO(100, 181, 246, 1),
  objects: [

    /* platforms  */
    Platforms(
      x: 250, 
      y: 300, 
      width: Globals.pixelSize * 3,
      type: PlatformType.block,
    ),
    Platforms(
      y: 300, 
      x: 300 + Globals.pixelSize * 2, 
      type: PlatformType.wall,
    ),
    Platforms(
      y: 250, 
      x: 1600 - Globals.pixelSize * 3, 
      width: Globals.pixelSize * 3,
      type: PlatformType.block,
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
      x: 330, 
      y: 100,
      type: PowerUpType.star
    ),
    
  ]
);

LevelData levelTwo = LevelData(
  size: const Size(720, 600), 
  scrollOffset: const Offset(0.0, 0.0),
  backgroundColor: const Color.fromARGB(255, 32, 32, 32),
  objects: [
    /* ground */
    Platforms(
      y: 600 - Globals.pixelSize, 
      width: 720, 
      type: PlatformType.ground,
    ),
  ]
);