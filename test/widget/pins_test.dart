import 'package:eventify/eventify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hanoi_tower_control/hanoi_tower_control.dart';
import 'package:hanoi_tower_game/events/events.dart';
import 'package:hanoi_tower_game/widget/game.dart' as ui_game;
import 'package:hanoi_tower_game/widget/pin.dart' as ui_pin;

void main() {
  Game game;
  PinEventController pinEventController;

  setUp(() {
    game = Game();
    pinEventController = PinEventController(new EventEmitter());
  });

  testWidgets('When starts with one disk in each pin then shows one disk in each pin', (WidgetTester tester) async {
    await game.start(3);
    Progress grabFromFirst = await game.grabFromFirstPin();
    await game.dropDiskInThirdPin(grabFromFirst.diskGrabbed);
    grabFromFirst = await game.grabFromFirstPin();
    Progress lastMove = await game.dropDiskInSecondPin(grabFromFirst.diskGrabbed);

    ui_pin.Pin widgetPin1 = ui_pin.Pin(lastMove.disksFirstPin(), pinEventController);
    ui_pin.Pin widgetPin2 = ui_pin.Pin(lastMove.disksSecondPin(), pinEventController);
    ui_pin.Pin widgetPin3 = ui_pin.Pin(lastMove.disksThirdPin(), pinEventController);

    ui_pin.Disk widgetDisk = ui_pin.Disk(grabFromFirst.diskGrabbed);

    await tester.pumpWidget(MaterialApp(home: ui_game.Pins(widgetDisk, widgetPin1, widgetPin2, widgetPin3)));

    await expectLater(find.byType(ui_game.Pins), matchesGoldenFile('pins_one_disk_in_each_pin.png'));
  });
}