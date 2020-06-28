import 'package:flutter/material.dart';
import 'package:hanoi_tower_game/widget/pin.dart' as ui_pin;


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
      child: Column(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: uiDisk,
          ),
          Flexible(
            flex: 20,
              child:_createPinsWithOrientation(context)
          )
        ],
      )
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