import 'package:eventify/eventify.dart';
import 'package:flutter/material.dart';
import 'package:hanoi_tower_control/hanoi_tower_control.dart';
import 'package:hanoi_tower_game/events/events.dart';
import 'package:hanoi_tower_game/widget/pin.dart' as ui_pin;

class Pins extends StatefulWidget {

  final PinDisks _initialFirstPin;
  final PinDisks _initialSecondPin;
  final PinDisks _initialThirdPin;

  Pins(this._initialFirstPin, this._initialSecondPin, this._initialThirdPin);

  @override
  _PinsState createState() => _PinsState(_initialFirstPin, _initialSecondPin, _initialThirdPin);
}

class _PinsState extends State<Pins> {

  PinDisks firstPin;
  PinDisks secondPin;
  PinDisks thirdPin;

  ui_pin.Pin uiFistPin;
  ui_pin.Pin uiSecondPin;
  ui_pin.Pin uiThirdPin;

  PinEvent eventControllerPin1 = PinEvent(EventEmitter());
  PinEvent eventControllerPin2 = PinEvent(EventEmitter());
  PinEvent eventControllerPin3 = PinEvent(EventEmitter());

  _PinsState(this.firstPin, this.secondPin, this.thirdPin) {
    uiFistPin = ui_pin.Pin(firstPin, eventControllerPin1);
    uiSecondPin = ui_pin.Pin(secondPin, eventControllerPin2);
    uiThirdPin = ui_pin.Pin(thirdPin, eventControllerPin3);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MediaQuery.of(context).orientation == Orientation.landscape ?
                _buildPinRows(context, uiFistPin, uiSecondPin, uiThirdPin):
                _buildPinColumns(context, uiFistPin, uiSecondPin, uiThirdPin)
    );
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
        child:firstPin.createState().build(context)
    ),
    Flexible(
        flex: 2,
        child:secondPin.createState().build(context)
    ),
    Flexible(
        flex: 2,
        child:thirdPin.createState().build(context)
    ),
  ];
}