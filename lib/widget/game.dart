import 'dart:math';

import 'package:eventify/eventify.dart';
import 'package:flutter/material.dart';
import 'package:hanoi_tower_control/hanoi_tower_control.dart' as control;
import 'package:hanoi_tower_game/events/events.dart';
import 'package:hanoi_tower_game/widget/pin.dart';
import 'package:hanoi_tower_game/widget/setup.dart';
import 'package:shared_preferences/shared_preferences.dart';


class GameHelper {
  final PinEventController _eventControllerPin1 = PinEventController(EventEmitter());
  final PinEventController _eventControllerPin2 = PinEventController(EventEmitter());
  final PinEventController _eventControllerPin3 = PinEventController(EventEmitter());
  final DiskEventController _eventControllerDisk = DiskEventController(EventEmitter());

  final control.Game _game = control.Game();

  control.Progress _lastProgress;

  Future<control.Progress> startGame(int totalDisks) {

    Future<control.Progress> result = _game.start(totalDisks);

    _updateLastProgress(result);

    return result;
  }

  Future<control.Progress> _grabDisk(int pinPosition) async {

    Future<control.Progress> result;

    switch (pinPosition) {
      case 1:
        {
          result =  _game.grabFromFirstPin();
          break;
        }
      case 2:
        {
          result = _game.grabFromSecondPin();
          break;
        }
      case 3:
        {
          result = _game.grabFromThirdPin();
          break;
        }
    }

    _updateLastProgress(result);

    return result;
  }

  Future<control.Progress> _dropDisk(int pinPosition)  {
    Future<control.Progress> result;

    switch (pinPosition) {
      case 1:
        {
          result = _game.dropDiskInFirstPin(_lastProgress.diskGrabbed);
          break;
        }
      case 2:
        {
          result = _game.dropDiskInSecondPin(lastProgress.diskGrabbed);
          break;
        }
      case 3:
        {
          result = _game.dropDiskInThirdPin(lastProgress.diskGrabbed);
          break;
        }
    }

    _updateLastProgress(result);

    return result;
  }

  Future<control.Progress> moveDisk(int pinPosition) {
    if (_lastProgress != null && _lastProgress.diskGrabbed != null) {
      return _dropDisk(pinPosition);
    } else {
      return _grabDisk(pinPosition);
    }
  }

  Future<void> _updateLastProgress(Future<control.Progress> currentProgress) async {
    _lastProgress = await currentProgress;
  }

  PinEventController get eventControllerPin1 => _eventControllerPin1;

  PinEventController get eventControllerPin2 => _eventControllerPin2;

  PinEventController get eventControllerPin3 => _eventControllerPin3;

  DiskEventController get eventControllerDisk => _eventControllerDisk;

  control.Progress get lastProgress => _lastProgress;

  bool get isGameStarted => _lastProgress != null;
}


class Game extends StatefulWidget {

  const Game({Key key}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final GameHelper _gameHelper = GameHelper();

  control.Progress _currentProgress;
  int _totalDisks;

  @override
  void initState() {
    super.initState();

    if (!_gameHelper.isGameStarted) {
      _getFromPreferencesTotalDisks().then((totalDisks) {
        _startGame(totalDisks);
      });
    } else {
      _update(_gameHelper.lastProgress);
    }
  }

  void _startGame(int totalDisks) async {
    setState(() {
      _totalDisks = totalDisks;
    });
    control.Progress startGame = await _gameHelper.startGame(totalDisks);
    _update(startGame);
    _updateDiskMoved(startGame);
  }

  void _updateDiskMoved(control.Progress moveDisk) async {

    _update(moveDisk);

    moveDisk.diskGrabbed == null
        ? _gameHelper.eventControllerDisk.fireDiskDropped()
        : _gameHelper.eventControllerDisk
            .fireDiskGrabbed(moveDisk.diskGrabbed);
  }

  @override
  Widget build(BuildContext context) {
    return Container(

      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(_totalDisks == null ? "Loading..." : "Finish up in ${_totalMoves(_totalDisks)} moves")
          ),
          drawer: Setup(totalDisks: _totalDisks,
            onAction: (totalDisks) {
            _saveInPreferencesTotalDisks(totalDisks);
            _startGame(totalDisks);
          },),
          body: Column(
            children: <Widget>[
              Flexible(
                flex: 2,
                child: _currentProgress == null ? Text("Loading...") :
                          Disk(disk:_currentProgress.diskGrabbed,
                            eventController: _gameHelper.eventControllerDisk,)
              ),
              Flexible(
                  flex: 20,
                  child:_createPinsWithOrientation(context)
              )
            ],
          )
      ),
    );
  }

  Flex _createPinsWithOrientation(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape ?
              _buildPinRows(context):
              _buildPinColumns(context);
  }

  Column _buildPinColumns(BuildContext context) {
    return Column(
      children: _buildAllPins(context),
    );
  }


  Row _buildPinRows(BuildContext context) {
    return Row(
      children: _buildAllPins(context),
    );
  }

  List<Widget> _buildAllPins(BuildContext context) {
    return <Widget>[
      Flexible(
          flex: 2,
          child:InkWell(
              onTap: () async {
                try {
                  control.Progress moveDisk = await _gameHelper.moveDisk(1);
                  _updateDiskMoved(moveDisk);
                  _gameHelper.eventControllerPin1
                      .firePinChangedEvent(moveDisk.disksFirstPin());
                } on ArgumentError catch(e) {
                  _talkToPlayer(e.message);
                } on StateError catch(e) {
                  _talkToPlayer(e.message);
                }
              },
              child: _currentProgress == null ? Text("Loading...") :
                      Pin(key: UniqueKey(), disks: _currentProgress.disksFirstPin(),
                          eventController: _gameHelper.eventControllerPin1)
          )
      ),
      Flexible(
          flex: 2,
          child:InkWell(
            onTap: () async {
              try  {
                control.Progress moveDisk = await _gameHelper.moveDisk(2);
                _updateDiskMoved(moveDisk);
                _gameHelper.eventControllerPin2
                    .firePinChangedEvent(moveDisk.disksSecondPin());
              } on ArgumentError catch(e) {
                _talkToPlayer(e.message);
              } on StateError catch(e) {
                _talkToPlayer(e.message);
              }
             },
            child: _currentProgress == null ? Text("Loading...") :
                    Pin(key: UniqueKey(), disks: _currentProgress.disksSecondPin(),
                          eventController: _gameHelper.eventControllerPin2),
          )
      ),
      Flexible(
          flex: 2,
          child:InkWell(
              onTap: () async {
                try {
                  control.Progress moveDisk = await _gameHelper.moveDisk(3);
                  _updateDiskMoved(moveDisk);
                  _gameHelper.eventControllerPin3
                      .firePinChangedEvent(moveDisk.disksThirdPin());
                  if (moveDisk.isGameOver) {
                    _showGameOver(context, moveDisk);
                  }
                } on ArgumentError catch(e) {
                  _talkToPlayer(e.message);
                } on StateError catch(e) {
                  _talkToPlayer(e.message);
                }
              },
              child: _currentProgress == null ? Text("Loading...") :
                        Pin(key: UniqueKey(), disks: _currentProgress.disksThirdPin(),
                              eventController: _gameHelper.eventControllerPin3)
          )
      ),
    ];
  }

  void _talkToPlayer(String message) {
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(
            content:Text(message, textAlign: TextAlign.center),
          duration: Duration(milliseconds: 750),
        )
    );
  }

  Future<void> _showGameOver(BuildContext context, control.Progress gameOver) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Kudos! Game is over!!!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('All disks were moved to third pin!'),
                Text('You did it in ${gameOver.moves} moves.'),
                Text('Your score is ${(gameOver.score() * 100).toInt()} out of 100.'),
                Visibility(
                  visible: gameOver.score() == 1,
                  child: Text('You played a perfect game!'),
                )
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Play again'),
              onPressed: () {
                Navigator.of(context).pop();
                _startGame(this._totalDisks);
              },
            ),
          ],
        );
      },
    );
  }

  void _update(control.Progress progress) {
    setState(() {
      _currentProgress = progress;
    });
  }

  int _totalMoves(disks) => pow(2, disks) - 1;

  void _saveInPreferencesTotalDisks(int totalDisks) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('totalDisks', totalDisks);
  }

  Future<int> _getFromPreferencesTotalDisks() async {
    final prefs = await SharedPreferences.getInstance();

    final result = prefs.getInt('totalDisks') == null ? 3 : prefs.getInt('totalDisks');
    return result;
  }
}
