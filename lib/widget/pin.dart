import 'package:flutter/material.dart';

class Pin extends StatefulWidget {
  @override
  _PinState createState() => _PinState();
}

class _PinState extends State<Pin> {

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

                      disk(190, 10, context),
                      disk(170, 9, context),
                      disk(150, 8, context),
                      disk(130, 7, context),
                      disk(110, 6, context),
                      disk(90, 5, context),
                      disk(70, 4, context),
                      disk(50, 3, context),
                      disk(30, 2, context),
                      disk(10, 1, context),

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
}

