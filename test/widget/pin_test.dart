import 'package:eventify/eventify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hanoi_tower_control/hanoi_tower_control.dart';
import 'package:hanoi_tower_game/events/events.dart';
import 'package:hanoi_tower_game/widget/pin.dart' as ui_game;

import '../events/events_test.dart';

void main() {
  Game game;
  PinEventController pinEvent;
  EventEmitter mockEventEmitter;

  setUp(() {
    game = Game();
    mockEventEmitter = MockEventEmitter();
    pinEvent = PinEventController(mockEventEmitter);
  });

  testWidgets('Golden test passes when starts game with 4 disks', (WidgetTester tester) async {

    Progress progress = await game.start(4);

    await tester.pumpWidget(MaterialApp(home: ui_game.Pin(progress.disksFirstPin(), pinEvent)));

    await expectLater(find.byType(ui_game.Pin), matchesGoldenFile('pin_start_with_4_disks.png'));
  });

  testWidgets('Golden test passes when starts game with minimum disks', (WidgetTester tester) async {

    Progress progress = await game.start(1);

    await tester.pumpWidget(MaterialApp(home: ui_game.Pin(progress.disksFirstPin(), pinEvent)));

    await expectLater(find.byType(ui_game.Pin), matchesGoldenFile('pin_start_with_min_disks.png'));
  });

  testWidgets('Golden test passes when starts game with maximum disks', (WidgetTester tester) async {
    Game game = Game();

    Progress progress = await game.start(10);

    await tester.pumpWidget(MaterialApp(home: ui_game.Pin(progress.disksFirstPin(), pinEvent)));

    await expectLater(find.byType(ui_game.Pin), matchesGoldenFile('pin_start_with_max_disks.png'));
  });

  testWidgets('Golden test passes when starts game with zero disks', (WidgetTester tester) async {
    Game game = Game();

    Progress progress = await game.start(1);

    await tester.pumpWidget(MaterialApp(home: ui_game.Pin(progress.disksSecondPin(), pinEvent)));

    await expectLater(find.byType(ui_game.Pin), matchesGoldenFile('pin_start_with_zero_disks.png'));
  });
}