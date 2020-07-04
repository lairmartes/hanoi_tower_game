import 'package:eventify/eventify.dart';
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
    EventCallback callback = (ev, context) { print("event received"); };

    test.addPinChangeEventListener(context, callback);

    verify(mockEventEmitter.on(any, context, callback));
  });

  test('When disk is grabbed then call emitter to disk grabbed event', () async {
    DiskEventController test = DiskEventController(mockEventEmitter);

    await game.start(5);

    Progress diskGrabbedProgress = await game.grabFromFirstPin();

    Disk diskGrabbed = diskGrabbedProgress.diskGrabbed;

    test.fireDiskGrabbed(diskGrabbed);

    verify(mockEventEmitter.emit(DiskEventController.diskGrabbedEvent, test, diskGrabbed));
  });

  test('When disk is dropped then call emitter to disk dropped event', ()  {
    DiskEventController test = DiskEventController(mockEventEmitter);

    test.fireDiskDropped();

    verify(mockEventEmitter.emit(DiskEventController.diskDroppedEvent, test));
  });

  test('When disk event listener is added then event is added to emitter for all events', () {
    DiskEventController test = DiskEventController(mockEventEmitter);

    Object context = Object();

    EventCallback callback = (ev, context) {
      print("event received");
    };
    
    test.addDiskChangedEventListener(context, callback);

    verify(mockEventEmitter.on(DiskEventController.diskDroppedEvent, context, callback));
    verify(mockEventEmitter.on(DiskEventController.diskGrabbedEvent, context, callback));
  });

  test('When listener is added to game events, then it is included in the emitter', () {
    GameEventController test = GameEventController(mockEventEmitter);

    Object context = Object();

    EventCallback callback = (ev, context) {
      print("event received");
    };

    test.addGameEventListener(context, callback);

    verify(mockEventEmitter.on(GameEventController.invalidMoveDetected, context,callback));
  });

  test('When invalid move event is launched, then emitter notifies listeners', () {
    GameEventController test = GameEventController(mockEventEmitter);

    var invalidMoveMessageTest = "Invalid Move message test";

    test.fireInvalidMoveDetected(invalidMoveMessageTest);

    verify(mockEventEmitter.emit(GameEventController.invalidMoveDetected, test,
        invalidMoveMessageTest));
  });
}


class MockEventEmitter extends Mock implements EventEmitter {

}