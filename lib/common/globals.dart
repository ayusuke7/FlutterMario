import 'dart:ui';

abstract class Globals {

  /* gameboard */
  static const screenSize = Size(800, 600);
  static const pixelSize = 48.0;
  static const gravity = 0.1;

  /* items size */
  static const platformSize = Size(48, 48);
  static const turtleSize = Size(32, 48);

  /* mario sprites */
  static const marioRun = [
    'assets/imgs/mario/run_1.png',
    'assets/imgs/mario/run_2.png',
    'assets/imgs/mario/run_3.png'
  ];
  static const marioIdle = 'assets/imgs/mario/idle.png';
  static const marioDie = 'assets/imgs/mario/die.png';
  static const marioJump = 'assets/imgs/mario/jump.png';
  static const fireBall = [
    'assets/imgs/items/fire_1.png',
    'assets/imgs/items/fire_2.png',
    'assets/imgs/items/fire_3.png'
  ];

  /* enemys sprites  */
  static const turtleRun = [
    'assets/imgs/enemys/enemy_1.png',
    'assets/imgs/enemys/enemy_2.png',
  ];
  static const spikeRun = [
    'assets/imgs/enemys/tick_1.png',
    'assets/imgs/enemys/tick_2.png',
  ];
  
  /* items sprites  */
  static const question = 'assets/imgs/items/question.png';
  static const pipe = 'assets/imgs/items/pipe.png';
  static const pipeLine = 'assets/imgs/items/pipe_line.png';
  static const cloud = 'assets/imgs/items/cloud.png';
  static const block = 'assets/imgs/items/block2.png';
  static const blockOff = 'assets/imgs/items/block_off.png';
  static const wall = 'assets/imgs/items/block.png';
  static const ground = 'assets/imgs/items/ground.png';
  static const coin = 'assets/imgs/items/coin.png';
  static const star = 'assets/imgs/items/star.png';
  static const flower = 'assets/imgs/items/flower.png';
  static const mushroom = 'assets/imgs/items/mushrom.png';
  static const steal = 'assets/imgs/items/steal.png';

}
