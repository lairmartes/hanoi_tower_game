import 'package:eventify/eventify.dart';
import 'package:flutter/material.dart';
import 'package:hanoi_tower_control/hanoi_tower_control.dart' as control;
import 'package:hanoi_tower_game/events/events.dart';
import 'package:hanoi_tower_game/widget/pin.dart' as ui_pin;


class GameController {
  final PinEventController _eventControllerPin1 = PinEventController(EventEmitter());
  final PinEventController _eventControllerPin2 = PinEventController(EventEmitter());
  final PinEventController _eventControllerPin3 = PinEventController(EventEmitter());

  final DiskEventController _diskEventController = DiskEventController(EventEmitter());
  
  bool _isGrabbing = true;

  control.Game _game = control.Game();

  Future<Pins> getGamePins(int totalDisks) async {
    var progress = await _game.start(totalDisks);

    var uiPin1 = ui_pin.Pin(key: UniqueKey(), initialPinDisks: progress.disksFirstPin(), pinEventController: _eventControllerPin1);
    var uiPin2 = ui_pin.Pin(key: UniqueKey(), initialPinDisks: progress.disksSecondPin(), pinEventController: _eventControllerPin2);
    var uiPin3 = ui_pin.Pin(key: UniqueKey(), initialPinDisks: progress.disksThirdPin(), pinEventController: _eventControllerPin3);

    var uiDisk = ui_pin.Disk(progress.diskGrabbed, _diskEventController);

    return Pins(uiDisk, uiPin1, uiPin2, uiPin3, pinAction);
  }
  
  void _notifyUI(PinEventController pinEventController, 
      DiskEventController diskEventController, 
      control.PinDisks updatedPinDisk, 
      control.Disk updatedDisk) {
    pinEventController.firePinChangedEvent(updatedPinDisk);
    if (updatedDisk != null) {
      diskEventController.fireDiskGrabbed(updatedDisk);
    } else {
      diskEventController.fireDiskDropped();
    }
  }
  
  void _grabDisk(int pinPosition) async {
    control.Progress progress = await _game.grabFromFirstPin();
    _notifyUI(_eventControllerPin1, _diskEventController, progress.disksFirstPin(), progress.diskGrabbed);
  }

  void pinAction(int pinPosition) {
    if (_isGrabbing) {
      _grabDisk(pinPosition);
      _isGrabbing = false;
    }
  }
}



class Game extends StatefulWidget {

  final Pins _pins;

  Game(this._pins);

  @override
  _GameState createState() => _GameState(_pins);
}

class _GameState extends State<Game> {

  Pins _pins;

  _GameState(this._pins);

  @override
  Widget build(BuildContext context) {
    return _pins;
  }
}


class Pins extends StatefulWidget {

  final ui_pin.Disk _uiDisk;

  final ui_pin.Pin _uiFistPin;
  final ui_pin.Pin _uiSecondPin;
  final ui_pin.Pin _uiThirdPin;

  final Function _pinActionCallBack;


  Pins(this._uiDisk, this._uiFistPin, this._uiSecondPin, this._uiThirdPin,
      this._pinActionCallBack);

  @override
  _PinsState createState() => _PinsState(this._uiDisk, this._uiFistPin,
      this._uiSecondPin, this._uiThirdPin, this._pinActionCallBack);
}

class _PinsState extends State<Pins> {

  ui_pin.Disk _uiDisk;

  ui_pin.Pin _uiFistPin;
  ui_pin.Pin _uiSecondPin;
  ui_pin.Pin _uiThirdPin;

  final Function _pinActionCallBack;

  _PinsState(this._uiDisk, this._uiFistPin, this._uiSecondPin, this._uiThirdPin,
      this._pinActionCallBack);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Scaffold(
          body: Column(
            children: <Widget>[
              Flexible(
                flex: 2,
                child: _uiDisk,
              ),
              Flexible(
                  flex: 20,
                  child:_createPinsWithOrientation(context, this._pinActionCallBack)
              )
            ],
          )
      ),
    );
  }

  Flex _createPinsWithOrientation(BuildContext context, Function pinActionCallBack) {
    return MediaQuery.of(context).orientation == Orientation.landscape ?
              _buildPinRows(context):
              _buildPinColumns(context);
  }

  Column _buildPinColumns(BuildContext context) {
    return Column(
      children: _buildAllPins(context),
    );
  }


  Row _buildPinRows(BuildContext context) {
    return Row(
      children: _buildAllPins(context),
    );
  }

  List<Widget> _buildAllPins(BuildContext context) {
    return <Widget>[
      Flexible(
          flex: 2,
          child:InkWell(
              onTap: () {
                _pinActionCallBack(1);
              },
              child: _uiFistPin
          )
      ),
      Flexible(
          flex: 2,
          child:InkWell(
            onTap: () {
              _pinActionCallBack(2);
            },
            child: _uiSecondPin,
          )
      ),
      Flexible(
          flex: 2,
          child:InkWell(
              onTap: () {
                _pinActionCallBack(3);
              },
              child: _uiThirdPin
          )
      ),
    ];
  }
}
