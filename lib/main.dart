import 'package:flutter/material.dart';
import 'package:hanoi_tower_game/widget/game.dart' as ui_game;

main() async {

  ui_game.GameController gameController = ui_game.GameController();

  ui_game.Game uiGame = await gameController.createGame(10);

  runApp(MaterialApp(home: uiGame));
}
