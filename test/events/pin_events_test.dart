import 'package:eventify/eventify.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hanoi_tower_control/hanoi_tower_control.dart';
import 'package:hanoi_tower_game/events/pin_events.dart';
import 'package:mockito/mockito.dart';

void main() {
  
  EventEmitter _mockEventEmitter;
  Game _game;

  setUp(() {
    _mockEventEmitter = MockEventEmitter();
    _game = Game();

  });
  
  test('When pin event is published then call emitter', () async {
    PinEvent test = PinEvent(_mockEventEmitter);

    Progress startGame = await _game.start(5);

    PinDisks pinEvent = startGame.disksFirstPin();

    test.firePinChangedEvent(pinEvent);

    verify(_mockEventEmitter.emit(PinEvent.pinDiskChangedEvent, test, pinEvent)).called(1);
  });
}


class MockEventEmitter extends Mock implements EventEmitter {

}