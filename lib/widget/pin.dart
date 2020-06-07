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
                      Center(
                        child: SizedBox(
                          width: 10.0,
                          height: 480.0,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.black
                            ),
                          ),
                        )
                      ),
                      Positioned(
                        top: 455,
                        left: 80,
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
                        top: 435,
                        left: 90,
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
                        top: 415,
                        left: 100,
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
                        top: 395,
                        left: 110,
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
                        top: 375,
                        left: 120,
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
                        top: 355,
                        left: 130,
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
                        top: 335,
                        left: 140,
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
                        top: 315,
                        left: 150,
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
                        top: 295,
                        left: 160,
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
                        top: 275,
                        left: 170,
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

  _updateFloor() {
    setState(() {
      _currentFloorPosition += 10;
    });
  }
}

