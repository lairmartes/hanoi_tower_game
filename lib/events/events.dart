import 'package:eventify/eventify.dart';
import 'package:flutter/material.dart';
import 'package:hanoi_tower_control/hanoi_tower_control.dart';

class PinEventController {
  final EventEmitter _emitter;

  static const pinDiskChangedEvent = 'pinDiskChanged';

  PinEventController(this._emitter);

  void firePinChangedEvent(final PinDisks newPin) {
    _emitter.emit(pinDiskChangedEvent, this, newPin);
  }

  void addPinChangeEventListener(Object context, EventCallback callback) {
    _emitter.on(pinDiskChangedEvent, context, callback);
  }
}

class DiskEventController {
  final EventEmitter _emitter;

  static const diskGrabbedEvent = 'diskGrabbed';
  static const diskDroppedEvent = 'diskDropped';

  DiskEventController(this._emitter);
  
  void fireDiskGrabbed(final Disk diskGrabbed) {
    _emitter.emit(diskGrabbedEvent, this, diskGrabbed);
  }
  
  void fireDiskDropped() {
    _emitter.emit(diskDroppedEvent, this);
  }

  void addDiskChangedEventListener(Object context, EventCallback callback) {
    _emitter.on(diskGrabbedEvent, context, callback);
    _emitter.on(diskDroppedEvent, context, callback);
  }
}

class GameEventController {
  final EventEmitter _emitter;

  static const invalidMoveDetected = 'invalidMoveDetected';
  static const gameProgressed = 'gameProgressed';

  GameEventController(this._emitter);

  void fireInvalidMoveDetected(final String message) {
    _emitter.emit(invalidMoveDetected, this, message);
  }

  void fireGameProgressed(final Progress progress) {
    _emitter.emit(gameProgressed, this, progress);
  }

  void addGameEventListener(Object context, EventCallback callback) {
    _emitter.on(invalidMoveDetected, context, callback);
    _emitter.on(gameProgressed, context, callback);
  }
}