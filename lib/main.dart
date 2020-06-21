import 'package:eventify/eventify.dart';
import 'package:flutter/material.dart';
import 'package:hanoi_tower_game/events/events.dart';
import 'package:hanoi_tower_game/widget/pin.dart' as ui_game;
import 'package:hanoi_tower_control/hanoi_tower_control.dart';

main() async {

  Game game = Game();

  Progress progress = await game.start(8);
  PinEvent pinEvent = PinEvent(EventEmitter());

  runApp(MaterialApp(home: ui_game.Pin(progress.disksFirstPin(), pinEvent)));
}
