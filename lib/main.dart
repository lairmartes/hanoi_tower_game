import 'package:flutter/material.dart';
import 'package:hanoi_tower_game/widget/game.dart' as ui_game;

main() async {

  ui_game.Game uiGame = ui_game.Game(initialDiskQuantity: 2);

  runApp(MaterialApp(home: uiGame));
}
