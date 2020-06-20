import 'package:eventify/eventify.dart';
import 'package:hanoi_tower_control/hanoi_tower_control.dart';

class PinEvent {
  final EventEmitter _emitter;

  static const pinDiskChangedEvent = 'pinDiskChanged';

  PinEvent(this._emitter);

  void firePinChangedEvent(final PinDisks newPin) {
    _emitter.emit(pinDiskChangedEvent, this, newPin);
  }
}