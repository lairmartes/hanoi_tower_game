import 'package:flutter/material.dart';
import 'package:hanoi_tower_control/hanoi_tower_control.dart';

class Pin extends StatefulWidget {

  final PinDisks _pinDisks;

  Pin(this._pinDisks);

  @override
  _PinState createState() => _PinState(this._pinDisks);
}

class _PinState extends State<Pin> {

  PinDisks _pinDisks;

  _PinState(this._pinDisks);

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
                    children: createPinWidged(context),
                  ),
                ],
              )
            ),
        ),
    );
  }

  List<Widget> createPinWidged(BuildContext context) {
    var result =  <Widget>[
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
                  ];
    var floor = 190.0;
    var disks = _pinDisks.disks.reversed;
    disks.forEach((element) {
      result.add(disk(floor, element.size, context));
      floor = floor - 20.0;
    });

    return result;
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

