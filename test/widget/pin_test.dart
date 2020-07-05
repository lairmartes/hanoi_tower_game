import 'package:eventify/eventify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hanoi_tower_control/hanoi_tower_control.dart' as control;
import 'package:hanoi_tower_game/events/events.dart';
import 'package:hanoi_tower_game/widget/pin.dart' as ui_game;

import '../events/events_test.dart';

void main() {
  control.Game game;
  PinEventController pinEventControl;
  EventEmitter mockEventEmitter;

  setUp(() {
    game = control.Game();
    mockEventEmitter = MockEventEmitter();
    pinEventControl = PinEventController(mockEventEmitter);
  });

  testWidgets('Golden test passes when starts game with 4 disks', (WidgetTester tester) async {

    control.Progress progress = await game.start(4);

    await tester.pumpWidget(MaterialApp(home: ui_game.Pin(progress.disksFirstPin(), pinEventControl)));

    await expectLater(find.byType(ui_game.Pin), matchesGoldenFile('pin_start_with_4_disks.png'));
  });

  testWidgets('Golden test passes when starts game with minimum disks', (WidgetTester tester) async {

    control.Progress progress = await game.start(1);

    await tester.pumpWidget(MaterialApp(home: ui_game.Pin(progress.disksFirstPin(), pinEventControl)));

    await expectLater(find.byType(ui_game.Pin), matchesGoldenFile('pin_start_with_min_disks.png'));
  });

  testWidgets('Golden test passes when starts game with maximum disks', (WidgetTester tester) async {

    control.Progress progress = await game.start(10);

    await tester.pumpWidget(MaterialApp(home: ui_game.Pin(progress.disksFirstPin(), pinEventControl)));

    await expectLater(find.byType(ui_game.Pin), matchesGoldenFile('pin_start_with_max_disks.png'));
  });

  testWidgets('Golden test passes when starts game with zero disks', (WidgetTester tester) async {

    control.Progress progress = await game.start(1);

    await tester.pumpWidget(MaterialApp(home: ui_game.Pin(progress.disksSecondPin(), pinEventControl)));

    await expectLater(find.byType(ui_game.Pin), matchesGoldenFile('pin_start_with_zero_disks.png'));
  });

  testWidgets('Golden test passes when starts with smaller disk', (WidgetTester tester) async {
    await game.start(1);

    control.Progress grabDiskProgress = await game.grabFromFirstPin();

    await tester.pumpWidget(MaterialApp(home: ui_game.Disk(grabDiskProgress.diskGrabbed, DiskEventController(mockEventEmitter))));

    await expectLater(find.byType(ui_game.Disk), matchesGoldenFile('disk_start_with_smallest.png'));
  });

  testWidgets('Golden test passes when starts with null disk', (WidgetTester tester) async {

    await game.start(1);

    await tester.pumpWidget(MaterialApp(home: ui_game.Disk(null, DiskEventController(mockEventEmitter))));

    await expectLater(find.byType(ui_game.Disk), matchesGoldenFile('disk_start_with_null_disk.png'));
  });
}