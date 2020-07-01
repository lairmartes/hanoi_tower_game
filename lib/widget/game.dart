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

  control.Game _game = control.Game();

  Future<Pins> getGamePins(int totalDisks) async {
    var progress = await _game.start(totalDisks);

    var uiPin1 = ui_pin.Pin(progress.disksFirstPin(), _eventControllerPin1);
    var uiPin2 = ui_pin.Pin(progress.disksSecondPin(), _eventControllerPin2);
    var uiPin3 = ui_pin.Pin(progress.disksThirdPin(), _eventControllerPin3);

    var uiDisk = ui_pin.Disk(progress.diskGrabbed, _diskEventController);

    return Pins(uiDisk, uiPin1, uiPin2, uiPin3);
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

  Pins(this._uiDisk, this._uiFistPin, this._uiSecondPin, this._uiThirdPin);

  @override
  _PinsState createState() => _PinsState(this._uiDisk, this._uiFistPin, this._uiSecondPin, this._uiThirdPin);
}

class _PinsState extends State<Pins> {

  ui_pin.Disk uiDisk;

  ui_pin.Pin uiFistPin;
  ui_pin.Pin uiSecondPin;
  ui_pin.Pin uiThirdPin;

  _PinsState(this.uiDisk, this.uiFistPin, this.uiSecondPin, this.uiThirdPin);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Scaffold(

          body: Column(
            children: <Widget>[
              Flexible(
                flex: 2,
                child: uiDisk,
              ),
              Flexible(
                  flex: 20,
                  child:_createPinsWithOrientation(context)
              )
            ],
          )

      ),

    );
  }

  Flex _createPinsWithOrientation(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape ?
              _buildPinRows(context, uiFistPin, uiSecondPin, uiThirdPin):
              _buildPinColumns(context, uiFistPin, uiSecondPin, uiThirdPin);
  }
}

Column _buildPinColumns(BuildContext context,
    ui_pin.Pin firstPin,
    ui_pin.Pin secondPin,
    ui_pin.Pin thirdPin) {
  return Column(
    children: _buildAllPins(firstPin, context, secondPin, thirdPin),
  );
}


Row _buildPinRows(BuildContext context,
    ui_pin.Pin firstPin,
    ui_pin.Pin secondPin,
    ui_pin.Pin thirdPin) {
  return Row(
    children: _buildAllPins(firstPin, context, secondPin, thirdPin),
  );
}

List<Widget> _buildAllPins(ui_pin.Pin firstPin, BuildContext context, ui_pin.Pin secondPin, ui_pin.Pin thirdPin) {
  return <Widget>[
    Flexible(
        flex: 2,
        child:InkWell(
          onTap: () {
            print("CLICOU NO PRIMEIRO PINO...");
          },
            child: firstPin.createState().build(context)
        )
    ),
    Flexible(
        flex: 2,
        child:InkWell(
          onTap: () {
            print("CLICOU NO SEGUNDO PINO...");
          },
            child: secondPin.createState().build(context),
        )
    ),
    Flexible(
        flex: 2,
        child:InkWell(
            onTap: () {
              print("CLICOU NO TERCEIRO PINO...");
            },
            child: thirdPin.createState().build(context)
        )
    ),
  ];
}