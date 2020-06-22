import 'package:eventify/eventify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hanoi_tower_control/hanoi_tower_control.dart';
import 'package:hanoi_tower_game/events/events.dart';
import 'package:mockito/mockito.dart';

void main() {
  
  EventEmitter mockEventEmitter;
  Game game;

  setUp(() {
    mockEventEmitter = MockEventEmitter();
    game = Game();

  });
  
  test('When pin event is published then call emitter', () async {
    PinEventController test = PinEventController(mockEventEmitter);

    Progress startGame = await game.start(5);

    PinDisks pinEvent = startGame.disksFirstPin();

    test.firePinChangedEvent(pinEvent);

    verify(mockEventEmitter.emit(any, test, pinEvent)).called(1);
  });

  test('When pin event listener is added then is added to emitter', () async {
    PinEventController test = PinEventController(mockEventEmitter);

    Object context = Object();
    EventCallback callback = (ev, context) { print("tnc"); };

    test.addPinChangeEventListener(context, callback);

    verify(mockEventEmitter.on(any, context, callback));
  });
}


class MockEventEmitter extends Mock implements EventEmitter {

}