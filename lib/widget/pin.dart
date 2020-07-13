import 'package:flutter/material.dart';
import 'package:hanoi_tower_control/hanoi_tower_control.dart' as control;
import 'package:hanoi_tower_game/events/events.dart';

final List<Color> _diskColors = List.unmodifiable([
  Colors.green[300],
  Colors.green[600],
  Colors.green[900],
  Colors.blue[300],
  Colors.blue[600],
  Colors.blue[900],
  Colors.purple[300],
  Colors.purple[600],
  Colors.purple[900],
  Colors.redAccent.shade700,
]
);

final Color _pinColor = Colors.grey.shade700;

class Pin extends StatefulWidget {

  final control.PinDisks disks;
  final PinEventController eventController;

  const Pin({Key key, this.disks, this.eventController}) : super(key: key);


  @override
  _PinState createState() => _PinState(this.disks, this.eventController);
}

class _PinState extends State<Pin> with AutomaticKeepAliveClientMixin {

  control.PinDisks _pinDisks;
  PinEventController _pinEventController;

  _PinState(this._pinDisks, this._pinEventController);

  @override
  void initState() {
    super.initState();
    this._pinEventController.addPinChangeEventListener(this, (ev, context) {
      _update(ev.eventData);
    });
  }

  @override
  void dispose() {
    super.dispose();
    this._pinEventController = null;
    this._pinDisks = null;
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
          left: _calculateMiddle(availableWidth, 7),
          bottom: 30,
          child: SizedBox(
            width: 7.0,
            height: availableHeight * .60,
            child: DecoratedBox(
              decoration: BoxDecoration(
                  color: _pinColor
              ),
            ),
          )
      ),

      Positioned(
        bottom: 20,
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
      var floor = 30.0;
      var disks = pinDisks.disks.reversed;
      disks.forEach((disk) {
        var left = _calculateMiddle(availableWidth, _calculateDiskWidth(availableWidth, disk.size));
        result.add(_createDisk(context, floor, left, disk.size, availableWidth));
        floor = floor + _calculateDiskHeight(context);
      });
    }

    return result;
  }

  _update(control.PinDisks newPinDisks) {
    if (this.mounted) {
      setState(() {
        this._pinDisks = newPinDisks;
      });
    }
  }

  @override
  bool get wantKeepAlive => true;
}

final double reduceDiskFactor = 0.75;



Widget _createDisk(BuildContext context, double positionTop,
                double positionLeft ,int diskSize, double availableWidth) {

  if (diskSize < 1) return _createDiskZero(positionTop, positionLeft);

  return Positioned(
    bottom: positionTop,
    left: positionLeft, //,
    child: SizedBox(
      width: _calculateDiskWidth(availableWidth, diskSize),
      height: _calculateDiskHeight(context),
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

  final control.Disk disk;
  final DiskEventController eventController;

  const Disk({Key key, this.disk, this.eventController}) : super(key: key);

  @override
  _DiskState createState() => _DiskState(this.disk, this.eventController);
}

class _DiskState extends State<Disk> {

  control.Disk _disk;
  DiskEventController _diskEventController;

  _DiskState(this._disk, this._diskEventController);

  @override
  void initState() {
    super.initState();
    this._diskEventController.addDiskChangedEventListener(this, (ev, context) {
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
        _createDisk(context, 1, 20, diskSize, availableWidth/parts)
      ],
    );
  }

  _update(control.Disk newDisk) {
    setState(() {
      this._disk = newDisk;
    });
  }
}

double _calculateDiskHeight(BuildContext context) {
  return MediaQuery.of(context).orientation == Orientation.landscape ? 24 : 15;
}