import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final List<String> sliderLabel = List.unmodifiable(
    ['Baby', 'Baby PowerUp',
      'Kid', 'Kid Menace',
      'Young', 'Young Bravo',
      'Intellectual', 'High Concentrated',
      'Viking', 'Viking Muléstia'] );

class Setup extends StatefulWidget {

  @override
  _SetupState createState() => _SetupState();
}

class _SetupState extends State<Setup> {
  int _totalDisks = 1;
  @override
  Widget build(BuildContext context) {
    return Drawer(
       child: Column(
         children: <Widget>[
           DrawerHeader(
             child: Text('Challenge: ${sliderLabel[_totalDisks - 1]}'),
           ),
           Slider(
             value: _totalDisks * 1.0,
             divisions: 10,
             min: 1.0,
             max: 10.0,
             label: sliderLabel[_totalDisks - 1],
             onChanged: (howManyDisks) {
               setState(() {
                 _totalDisks = howManyDisks.round();
               });
             },
           ),
           RaisedButton(
            child: Text('New Game'),
             onPressed: () {
                Navigator.pop(context);
              }
           )
         ],
       ),
    );
  }
}
