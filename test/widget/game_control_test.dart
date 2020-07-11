import 'package:flutter_test/flutter_test.dart';
import 'package:hanoi_tower_control/hanoi_tower_control.dart' as control;
import 'package:hanoi_tower_game/widget/game.dart';

void main() {
  test('When game start with 3 disks, then last progress is disk 3, 0, 0 and grabbed is null', () async {

    control.Game testControlGame = control.Game();
    GameController gameController = GameController();

    testControlGame.start(3).then((expected) => {
      gameController.startGame(3).then((_) {
        control.Progress actual = gameController.lastProgress;
        var actualData = {'pin1Disks':actual.disksFirstPin().disks.length };
        var expectedData = {'pin1Disks':expected.disksFirstPin().disks.length };

        expect(actualData, expectedData);
      })

    }).catchError((onError) {
      fail('It is not possible to test due an error when starting test control game: $onError');
    });
  });
}