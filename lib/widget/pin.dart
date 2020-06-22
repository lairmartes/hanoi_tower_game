import 'package:flutter/material.dart';
import 'package:hanoi_tower_control/hanoi_tower_control.dart';
import 'package:hanoi_tower_game/events/events.dart';

class Pin extends StatefulWidget {

  final PinDisks _initialPinDisks;
  final PinEvent _pinEventController;

  Pin(this._initialPinDisks, this._pinEventController);

  @override
  _PinState createState() => _PinState(this._initialPinDisks, this._pinEventController);
}

class _PinState extends State<Pin> {

  PinDisks _pinDisks;

  _PinState(this._pinDisks, PinEvent pinEvent) {
    pinEvent.addPinChangeEventListener(this, (ev, context) { 
      updatePin(ev.eventData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) =>
            Container(
              child: _buildPin(context, this._pinDisks)
            ),
        ),
    );
  }

  updatePin(PinDisks pinDisks) {
    setState(() {
      this._pinDisks = pinDisks;
    });
  }
}

final double reduceDiskFactor = 0.80;

final List<Color> _diskColors = List.unmodifiable([
    Colors.purpleAccent.shade100,
    Colors.greenAccent.shade200,
    Colors.redAccent.shade100,
    Colors.blueAccent.shade400,
    Colors.purpleAccent.shade400,
    Colors.greenAccent.shade400,
    Colors.redAccent.shade400,
    Colors.blueAccent.shade400,
    Colors.purpleAccent.shade700,
    Colors.greenAccent.shade700,
  ]
);

final Color _pinColor = Colors.grey.shade700;

Stack _buildPin(BuildContext context, pinDisks) {
  return Stack(
        children: _insertDisks(context, pinDisks),
      );
}

List<Widget> _insertDisks(BuildContext context, pinDisks) {
  var availableHeight = MediaQuery.of(context).size.height;
  if (MediaQuery.of(context).orientation == Orientation.portrait) {
    availableHeight = availableHeight / 3;
  }

  var availableWidth = MediaQuery.of(context).size.width;
  if (MediaQuery.of(context).orientation == Orientation.landscape) {
    availableWidth = availableWidth / 3;
  }
  var result =  <Widget>[
    Positioned(
        left: _calculateMiddle(availableWidth, 10),
        bottom: 10,
        child: SizedBox(
          width: 10.0,
          height: availableHeight * reduceDiskFactor,
          child: DecoratedBox(
            decoration: BoxDecoration(
                color: _pinColor
            ),
          ),
        )
    ),

    Positioned(
      top: availableHeight - 10,
      left: _calculateMiddle(availableWidth, _calculateDiskWidth(availableWidth, 10)),
      child: SizedBox(
        width: availableWidth * reduceDiskFactor,
        height: 10.0,
        child: DecoratedBox(
          decoration: BoxDecoration(
              color: _pinColor
          ),
        ),
      ),
    ),
  ];

  if (pinDisks != null) {
    var floor = availableHeight - 30;
    var disks = pinDisks.disks.reversed;
    disks.forEach((disk) {
      result.add(_disk(floor, disk.size, availableWidth));
      floor = floor - 20.0;
    });
  }

  return result;
}

Widget _disk(double positionTop, int diskSize, double availableWidth) {

  return Positioned(
    top: positionTop,
    left: _calculateMiddle(availableWidth, _calculateDiskWidth(availableWidth, diskSize)),
    child: SizedBox(
      width: _calculateDiskWidth(availableWidth, diskSize),
      height: 20,
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: _diskColors.elementAt(diskSize-1)
        ),
      ),
    ),
  );
}

_calculateMiddle(totalWidth, diskWidth) => totalWidth / 2 - ( diskWidth / 2 );

_calculateDiskWidth(double availableWidth, int diskSize) => availableWidth * reduceDiskFactor - 20 * ( 10 - diskSize );