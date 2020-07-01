import 'package:flutter/material.dart';
import 'package:hanoi_tower_control/hanoi_tower_control.dart' as control;
import 'package:hanoi_tower_game/events/events.dart';

class Pin extends StatefulWidget {

  final control.PinDisks initialPinDisks;
  final PinEventController pinEventController;

  const Pin({Key key, this.initialPinDisks, this.pinEventController}) : super(key: key);


  @override
  _PinState createState() => _PinState(this.initialPinDisks, this.pinEventController);
}

class _PinState extends State<Pin> with AutomaticKeepAliveClientMixin {

  control.PinDisks _pinDisks;

  _PinState(this._pinDisks, PinEventController pinEvent) {
    pinEvent.addPinChangeEventListener(this, (ev, context) { 
      _update(ev.eventData);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _buildPin(context, _pinDisks);
  }

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
          bottom: 5,
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
        //top: availableHeight - 20,
        bottom: 5,
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
      var floor = 15.0;
      var disks = pinDisks.disks.reversed;
      disks.forEach((disk) {
        var left = _calculateMiddle(availableWidth, _calculateDiskWidth(availableWidth, disk.size));
        result.add(_createDisk(floor, left, disk.size, availableWidth));
        floor = floor + 20.0;
      });
    }

    return result;
  }

  _update(control.PinDisks newPinDisks) {
    print("TAH MONTADO FILHO DA PUTA??? " + this.mounted.toString());
     setState(() {
      this._pinDisks = newPinDisks;
    });
  }

  @override
  bool get wantKeepAlive => true;
}

final double reduceDiskFactor = 0.75;

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



Widget _createDisk(double positionTop, double positionLeft ,int diskSize, double availableWidth) {

  if (diskSize < 1) return _createDiskZero(positionTop, positionLeft);

  return Positioned(
    bottom: positionTop,
    left: positionLeft, //,
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

Widget _createDiskZero(double positionTop, double positionLeft) {
  return Positioned(
    bottom: positionTop,
    left: positionLeft, //,
    child: SizedBox(
    ),
  );
}

_calculateMiddle(totalWidth, diskWidth) => totalWidth / 2 - ( diskWidth / 2 );

_calculateDiskWidth(double availableWidth, int diskSize) => availableWidth * reduceDiskFactor - 20 * ( 10 - diskSize );


class Disk extends StatefulWidget {

  final control.Disk _initialDisk;
  final DiskEventController _diskEventController;

  Disk(this._initialDisk, this._diskEventController);

  @override
  _DiskState createState() => _DiskState(this._initialDisk, this._diskEventController);
}

class _DiskState extends State<Disk> {

  control.Disk _disk;

  _DiskState(this._disk, DiskEventController diskEventController) {
    diskEventController.addDiskChangedEventListener(this, (ev, context) {
      _update(ev.eventData);
    });
  }

  @override
  Widget build(BuildContext context) {
    var availableWidth = MediaQuery.of(context).size.width;
    var parts = MediaQuery.of(context).orientation == Orientation.landscape ? 3 : 1;
    var diskSize = _disk == null ? 0 : _disk.size;

    return Stack (
      children: <Widget>[
        Scaffold(
        ),
        _createDisk(1, 20, diskSize, availableWidth/parts)
      ],
    );
  }

  _update(control.Disk newDisk) {
    setState(() {
      this._disk = newDisk;
    });
  }
}
