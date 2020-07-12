import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final List<String> sliderLabel = List.unmodifiable(
    ['Baby', 'Baby PowerUp',
      'Kid', 'Kid Menace',
      'Young', 'Young Bravo',
      'Intellectual', 'High Concentrated',
      'Viking', "I've meant it!"]);

class Setup extends StatefulWidget {

  final int totalDisks;
  final Function onAction;

  const Setup({Key key, this.totalDisks, this.onAction}) : super(key: key);

  @override
  _SetupState createState() => _SetupState(this.totalDisks, this.onAction);
}

class _SetupState extends State<Setup> {
  int _totalDisks = 1;
  Function _action;

  _SetupState(this._totalDisks, this._action);

  @override
  Widget build(BuildContext context) {
    return Drawer(
       child: Column(
         children: <Widget>[
           DrawerHeader(
             child: Image.asset('images/levels/level_$_totalDisks.png', alignment: Alignment.center,),
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
                _action(_totalDisks);
                Navigator.pop(context);
              }
           )
         ],
       ),
    );
  }
}
