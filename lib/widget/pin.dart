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
                        child: Image.asset("images/disks/pin.png",),
                      ),
                      Positioned(
                        top: 455,
                        left: 75,
                        child: Image.asset("images/disks/10.png", scale: 3,),
                      ),
                      Positioned(
                        top: 435,
                        left: 90,
                        child: Image.asset("images/disks/9.png", scale: 3,),
                      ),
                      Positioned(
                        top: 415,
                        left: 105,
                        child: Image.asset("images/disks/8.png", scale: 3,),
                      ),
                      Positioned(
                        top: 395,
                        left: 120,
                        child: Image.asset("images/disks/7.png", scale: 3,),
                      ),
                      Positioned(
                        top: 375,
                        left: 135,
                        child: Image.asset("images/disks/6.png", scale: 3,),
                      ),
                      Positioned(
                        top: 355,
                        left: 150,
                        child: Image.asset("images/disks/5.png", scale: 3,),
                      ),
                      Positioned(
                        top: 335,
                        left: 165,
                        child: Image.asset("images/disks/4.png", scale: 3,),
                      ),
                      Positioned(
                        top: 315,
                        left: 180,
                        child: Image.asset("images/disks/3.png", scale: 3,),
                      ),
                      Positioned(
                        top: 295,
                        left: 190,
                        child: Image.asset("images/disks/2.png", scale: 3,),
                      ),
                      Positioned(
                        top: 275,
                        left: 195,
                        child: Image.asset("images/disks/1.png", scale: 3,),
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

