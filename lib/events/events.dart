import 'package:eventify/eventify.dart';
import 'package:hanoi_tower_control/hanoi_tower_control.dart';

class PinEventController {
  final EventEmitter _emitter;

  static const _pinDiskChangedEvent = 'pinDiskChanged';

  PinEventController(this._emitter);

  void firePinChangedEvent(final PinDisks newPin) {
    _emitter.emit(_pinDiskChangedEvent, this, newPin);
  }

  void addPinChangeEventListener(Object context, EventCallback callback) {
    _emitter.on(_pinDiskChangedEvent, context, callback);
  }
}