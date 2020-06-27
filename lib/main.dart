import 'package:eventify/eventify.dart';
import 'package:flutter/material.dart';
import 'package:hanoi_tower_game/events/events.dart';
import 'package:hanoi_tower_game/widget/game.dart';
import 'package:hanoi_tower_control/hanoi_tower_control.dart';
import 'package:hanoi_tower_game/widget/pin.dart' as ui_pin;

main() async {

  Game game = Game();

  Progress progress = await game.start(10);

  PinEventController pin1EventController = PinEventController(EventEmitter());
  PinEventController pin2EventController = PinEventController(EventEmitter());
  PinEventController pin3EventController = PinEventController(EventEmitter());

  ui_pin.Pin widgetPin1 = ui_pin.Pin(progress.disksFirstPin(), pin1EventController);
  ui_pin.Pin widgetPin2 = ui_pin.Pin(progress.disksSecondPin(), pin2EventController);
  ui_pin.Pin widgetPin3 = ui_pin.Pin(progress.disksThirdPin(), pin3EventController);

  Pins pins = Pins(widgetPin1, widgetPin2, widgetPin3);

  Progress grab = await game.grabFromFirstPin();

  ui_pin.Disk widgetDisk = ui_pin.Disk(grab.diskGrabbed);

  runApp(MaterialApp(home: pins));
}
