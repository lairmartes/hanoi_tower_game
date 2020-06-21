import 'package:flutter/material.dart';
import 'package:hanoi_tower_game/widget/game.dart';
import 'package:hanoi_tower_control/hanoi_tower_control.dart';

main() async {

  Game game = Game();

  Progress progress = await game.start(10);
  Pins pins = Pins(progress.disksFirstPin(), progress.disksSecondPin(), progress.disksThirdPin());

  runApp(MaterialApp(home: pins));
}
