import 'package:eventify/eventify.dart';
import 'package:flutter/material.dart';
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

class DiskEventController {
  final EventEmitter _emitter;

  static const _diskGrabbed = 'diskGrabbed';
  static const _diskDropped = 'diskDropped';

  DiskEventController(this._emitter);
  
  void fireDiskGrabbed(final Disk diskGrabbed) {
    _emitter.emit(_diskGrabbed, this, diskGrabbed);
  }
  
  void fireDiskDropped() {
    _emitter.emit(_diskDropped, this);
  }

  void addDiskChangedEventListener(Object context, EventCallback callback) {
    _emitter.on(_diskGrabbed, context, callback);
    _emitter.on(_diskDropped, context, callback);
  }
}