import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_platform_game/game_board.dart';
import 'package:flutter_platform_game/common/levels.dart';

class GameLoader extends StatefulWidget {
  const GameLoader({super.key});

  @override
  State<GameLoader> createState() => _GameOverState();
}

class _GameOverState extends State<GameLoader> {

  List<LevelData> levels = [levelOne, levelTwo];

  int level = -1;
  String title = '';
  String substitle = '3s';


  void _timer(VoidCallback fn) {
    Timer.periodic(const Duration(seconds: 1), (t) async {
      var second = (3 - t.tick);
      setState(() { substitle = '${second}s'; });

      if (second == 0) {
        t.cancel();
        fn();
      }
    });
  }

  void _gameOver() {
    setState(() { 
      title = 'GAME OVER'; 
      substitle = '3s'; 
    });
    _loadLevel(); 
  }

  void _nextLevel() {
    setState(() { 
      level++;
      title = 'WORLD ${level+1} - ${levels.length}';
    });
    _loadLevel();
  }

  void _loadLevel() {
    _timer(() async {

      LevelData l = LevelData.copy(levels[level]);
      bool die = await Navigator.push(context, MaterialPageRoute(
        builder: (_) => GameBoard(level: l)
      ));

      if (die) { 
        _gameOver(); 
      } else {
        _nextLevel();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      _nextLevel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 30),
            Text(substitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold
              ),
            )
          ],
        ),
      ),
    );
  }
}