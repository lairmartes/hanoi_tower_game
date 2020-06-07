import 'package:flutter/material.dart';

class Pin extends StatefulWidget {
  @override
  _PinState createState() => _PinState();
}

class _PinState extends State<Pin> {
  int _currentFloorPosition = 0;

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

                      Positioned(
                        top: 190,
                        left: _calculateMiddle(MediaQuery.of(context).size.width, 250),
                        child: SizedBox(
                          width: 250,
                          height: 20,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.redAccent
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 170,
                        left: _calculateMiddle(MediaQuery.of(context).size.width, 230),
                        child: SizedBox(
                          width: 230,
                          height: 20,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                color: Colors.greenAccent
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 150,
                        left: _calculateMiddle(MediaQuery.of(context).size.width, 210),
                        child: SizedBox(
                          width: 210,
                          height: 20,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                color: Colors.orange
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 130,
                        left: _calculateMiddle(MediaQuery.of(context).size.width, 190),
                        child: SizedBox(
                          width: 190,
                          height: 20,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                color: Colors.blue
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 110,
                        left: _calculateMiddle(MediaQuery.of(context).size.width, 170),
                        child: SizedBox(
                          width: 170,
                          height: 20,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                color: Colors.green
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 90,
                        left: _calculateMiddle(MediaQuery.of(context).size.width, 150),
                        child: SizedBox(
                          width: 150,
                          height: 20,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                color: Colors.purple
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 70,
                        left: _calculateMiddle(MediaQuery.of(context).size.width, 130),
                        child: SizedBox(
                          width: 130,
                          height: 20,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                color: Colors.lightBlue
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 50,
                        left: _calculateMiddle(MediaQuery.of(context).size.width, 110),
                        child: SizedBox(
                          width: 110,
                          height: 20,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                color: Colors.red
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 30,
                        left: _calculateMiddle(MediaQuery.of(context).size.width, 90),
                        child: SizedBox(
                          width: 90,
                          height: 20,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                color: Colors.lightGreen
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        left: _calculateMiddle(MediaQuery.of(context).size.width, 70),
                        child: SizedBox(
                          width: 70,
                          height: 20,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                color: Colors.deepPurple
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ),
        ),
    );
  }

  _calculateMiddle(totalWidth, diskWidth) => totalWidth / 2 - ( diskWidth /2 );

  _updateFloor() {
    setState(() {
      _currentFloorPosition += 10;
    });
  }
}

