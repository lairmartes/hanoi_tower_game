import 'package:flutter/material.dart';
import 'package:hanoi_tower_control/hanoi_tower_control.dart';

class Pin extends StatefulWidget {
  @override
  _PinState createState() => _PinState();
}

class _PinState extends State<Pin> {

  PinDisks _pinDisks;

  List<Color> _diskColors = List.unmodifiable([
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) =>
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 10.0,
                          height: 225.0,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade700
                            ),
                          ),
                        )
                      ),

                        Positioned(
                          top: 215,
                          left: _calculateMiddle(MediaQuery.of(context).size.width, 250),
                          child: SizedBox(
                            width: 250.0,
                            height: 10.0,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade700
                              ),
                            ),
                          ),
                        ),

                      _pinDisks.disks.elementAt(0) == null ? null : disk(190, _pinDisks.disks.elementAt(0).size, context),
                      _pinDisks.disks.elementAt(1) == null ? null : disk(170, _pinDisks.disks.elementAt(1).size, context),
                      _pinDisks.disks.elementAt(2) == null ? null : disk(150, _pinDisks.disks.elementAt(2).size, context),
                      _pinDisks.disks.elementAt(3) == null ? null : disk(130, _pinDisks.disks.elementAt(3).size, context),
                      _pinDisks.disks.elementAt(4) == null ? null : disk(110, _pinDisks.disks.elementAt(4).size, context),
                      _pinDisks.disks.elementAt(5) == null ? null : disk(90, _pinDisks.disks.elementAt(5).size, context),
                      _pinDisks.disks.elementAt(6) == null ? null : disk(70, _pinDisks.disks.elementAt(6).size, context),
                      _pinDisks.disks.elementAt(7) == null ? null : disk(50, _pinDisks.disks.elementAt(7).size, context),
                      _pinDisks.disks.elementAt(8) == null ? null : disk(30, _pinDisks.disks.elementAt(8).size, context),
                      _pinDisks.disks.elementAt(9) == null ? null : disk(10, _pinDisks.disks.elementAt(9).size, context),

                    ],
                  ),
                ],
              )
            ),
        ),
    );
  }

  _calculateMiddle(totalWidth, diskWidth) => totalWidth / 2 - ( diskWidth / 2 );
  
  double _calculateDiskWidth(int diskSize) => 250.0 - 20 * ( 10 - diskSize );

  Widget disk(double positionTop, int diskSize, BuildContext context) {
    return Positioned(
      top: positionTop,
      left: _calculateMiddle(MediaQuery.of(context).size.width, _calculateDiskWidth(diskSize)),
      child: SizedBox(
        width: _calculateDiskWidth(diskSize),
        height: 20,
        child: DecoratedBox(
          decoration: BoxDecoration(
              color: _diskColors.elementAt(diskSize-1)
          ),
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

