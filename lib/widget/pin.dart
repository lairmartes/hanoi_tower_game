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

class Position {
  final double x;
  final double y;

  const Position({this.x, this.y});
}

class Dimension {
  final double width;
  final double height;

  Dimension(this.width, this.height);
}

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
    return Stack(
        children: <Widget>[
          PinView(),
          DiskStacker(pinDisks: _pinDisks,)
        ]
    );
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

class PinView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
            left: _calculateMiddle(context, 10) + 7,
            bottom: 30,
            child: SizedBox(
              width: 10.0,
              height: 10.0 * (MediaQuery.of(context).orientation == Orientation.landscape ? 24 : 15),
              child: DecoratedBox(
                decoration: BoxDecoration(
                    color: _pinColor
                ),
              ),
            )
        ),

        Positioned(
          bottom: 20,
          left: 7,
          child: SizedBox(
            width: _calculateAvailableWidth(context),
            height: 10.0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                  color: _pinColor
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DiskStacker extends StatelessWidget {

  final control.PinDisks pinDisks;
  final double floor = 30.0;

  const DiskStacker({Key key, this.pinDisks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children:
        this.pinDisks.disks.reversed.toList().asMap().map((index, disk) =>
            MapEntry(index, DiskView(position: _calculatePosition(context, disk, index),
                disk: disk))).values.toList(growable: false),
    );
  }

  Position _calculatePosition(BuildContext context, control.Disk disk, int index) {
    double x = _calculateMiddle(context, _calculateDiskWidth(context, disk)) + 7;
    double y = floor + _calculateDiskHeight(context, disk) * index;
    return Position(x: x, y: y);
  }
}



class DiskView extends StatelessWidget {

  final Position position;
  final control.Disk disk;

  const DiskView({Key key, this.position, this.disk}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: position.y,
      left: position.x,
      child: disk == null ? SizedBox() : SizedBox(
        width: _calculateDiskWidth(context, disk),
        height: _calculateDiskHeight(context, disk),
        child: DecoratedBox(
          decoration: BoxDecoration(
              color: _diskColors.elementAt(disk.size-1)
          ),
        ),
      ),
    );
  }
}


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

    return Stack (
      children: <Widget>[
        Scaffold(
        ),
        DiskView(disk: _disk,
            position: Position(x: 20, y: 1)
        ),
      ],
    );
  }

  _update(control.Disk disk) {
    setState(() {
      this._disk = disk;
    });
  }
}

double _calculateDiskHeight(BuildContext context, control.Disk disk) =>
  disk == null ? 0 : MediaQuery.of(context).orientation == Orientation.landscape ? 24 : 15;

double _calculateDiskWidth(BuildContext context, control.Disk disk) =>
    disk == null ? 0 : _calculateAvailableWidth(context) - 20 * (10 - disk.size);

double _calculateAvailableWidth(BuildContext context) =>
    MediaQuery.of(context).size.width / (MediaQuery.of(context).orientation == Orientation.landscape ? 3 : 1) * 0.95;

double _calculateMiddle(BuildContext context, diskWidth) => _calculateAvailableWidth(context) / 2 - ( diskWidth / 2 );

