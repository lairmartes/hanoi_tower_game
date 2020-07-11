import 'package:flutter_test/flutter_test.dart';
import 'package:hanoi_tower_control/hanoi_tower_control.dart' as control;
import 'package:hanoi_tower_game/widget/game.dart';

void main() {
  test('When game start with 3 disks, then last progress is equal to test game progress', () async {

    control.Game testControlGame = control.Game();
    GameController gameController = GameController();

    control.Progress expected = await testControlGame.start(3);

    await gameController.startGame(3);

    control.Progress actual = gameController.lastProgress;

    expect(actual, expected);
  });

  test('When disk is grabbed, then las progress is equal to the test game progress', () async {

    control.Game testControlGame = control.Game();
    GameController gameController = GameController();

    await testControlGame.start(3);
    control.Progress expected = await testControlGame.grabFromFirstPin();

    await gameController.startGame(3);
    await gameController.moveDisk(1);

    control.Progress actual = gameController.lastProgress;

    expect(actual, expected);
  });

  test('When moved from disk 1 to disk 2, then las progress is equal to the test game progress', () async {

    control.Game testControlGame = control.Game();
    GameController gameController = GameController();

    await testControlGame.start(3);
    var grabDisk = await testControlGame.grabFromFirstPin();
    var expected = await testControlGame.dropDiskInSecondPin(grabDisk.diskGrabbed);

    await gameController.startGame(3);
    await gameController.moveDisk(1);
    await gameController.moveDisk(2);

    control.Progress actual = gameController.lastProgress;

    expect(actual, expected);
  });
}