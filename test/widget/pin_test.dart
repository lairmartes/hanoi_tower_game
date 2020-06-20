import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hanoi_tower_control/hanoi_tower_control.dart';
import 'package:hanoi_tower_game/widget/pin.dart' as ui_game;

void main() {
  testWidgets('Golden test passes when starts game with 4 disks', (WidgetTester tester) async {
    Game game = Game();

    Progress progress = await game.start(4);

    await tester.pumpWidget(MaterialApp(home: ui_game.Pin(progress.disksFirstPin())));

    await expectLater(find.byType(ui_game.Pin), matchesGoldenFile('pin_start_with_4_disks.png'));
  });

  testWidgets('Golden test passes when starts game with minimum disks', (WidgetTester tester) async {
    Game game = Game();

    Progress progress = await game.start(1);

    await tester.pumpWidget(MaterialApp(home: ui_game.Pin(progress.disksFirstPin())));

    await expectLater(find.byType(ui_game.Pin), matchesGoldenFile('pin_start_with_min_disks.png'));
  });

  testWidgets('Golden test passes when starts game with maximum disks', (WidgetTester tester) async {
    Game game = Game();

    Progress progress = await game.start(10);

    await tester.pumpWidget(MaterialApp(home: ui_game.Pin(progress.disksFirstPin())));

    await expectLater(find.byType(ui_game.Pin), matchesGoldenFile('pin_start_with_max_disks.png'));
  });
  
  testWidgets('Golden test passes when one disk is removed from a pin with 4 disks', (WidgetTester tester) async {

    Game game = Game();

    Progress progressStart = await game.start(4);

    var uiPin = ui_game.Pin(progressStart.disksFirstPin());

    game.grabFromFirstPin();

  });
}