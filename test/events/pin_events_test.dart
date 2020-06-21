import 'package:eventify/eventify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hanoi_tower_control/hanoi_tower_control.dart';
import 'package:hanoi_tower_game/events/events.dart';
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

    verify(_mockEventEmitter.emit(any, test, pinEvent)).called(1);
  });

  test('When pin event listener is added then is added to emitter', () async {
    PinEvent test = PinEvent(_mockEventEmitter);

    Object context = Object();
    EventCallback callback = (ev, context) { print("tnc"); };

    test.addPinChangeEventListener(context, callback);

    verify(_mockEventEmitter.on(any, context, callback));
  });
}


class MockEventEmitter extends Mock implements EventEmitter {

}