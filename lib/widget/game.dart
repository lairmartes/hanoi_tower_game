import 'dart:math';

import 'package:eventify/eventify.dart';
import 'package:flutter/material.dart';
import 'package:hanoi_tower_control/hanoi_tower_control.dart' as control;
import 'package:hanoi_tower_game/events/events.dart';
import 'package:hanoi_tower_game/widget/pin.dart' as ui_pin;
import 'package:hanoi_tower_game/widget/setup.dart';
import 'package:shared_preferences/shared_preferences.dart';


class GameController {
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

  final GameController _gameController = GameController();
  int _totalDisks;

  ui_pin.Disk _uiDisk;
  ui_pin.Pin _uiFirstPin;
  ui_pin.Pin _uiSecondPin;
  ui_pin.Pin _uiThirdPin;

  @override
  void initState() {
    super.initState();

    if (!_gameController.isGameStarted) {
      _getFromPreferencesTotalDisks().then((totalDisks) { _startGame(totalDisks); });
    } else {
      _update(_gameController.lastProgress);
    }
  }

  void _startGame(int totalDisks) async {
    setState(() {
      _totalDisks = totalDisks;
    });
    control.Progress startGame = await _gameController.startGame(totalDisks);
    _update(startGame);
  }

  void _updateDiskMoved(control.Progress moveDisk) async {

    _update(moveDisk);

    moveDisk.diskGrabbed == null
        ? _gameController.eventControllerDisk.fireDiskDropped()
        : _gameController.eventControllerDisk
            .fireDiskGrabbed(moveDisk.diskGrabbed);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
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
                child: _uiDisk == null ? Text("Waiting...") : _uiDisk
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
                  control.Progress moveDisk = await _gameController.moveDisk(1);
                  _updateDiskMoved(moveDisk);
                  _gameController.eventControllerPin1
                      .firePinChangedEvent(moveDisk.disksFirstPin());
                } on ArgumentError catch(e) {
                  _talkToPlayer(e.message);
                } on StateError catch(e) {
                  _talkToPlayer(e.message);
                }
              },
              child: _uiFirstPin
          )
      ),
      Flexible(
          flex: 2,
          child:InkWell(
            onTap: () async {
              try  {
                control.Progress moveDisk = await _gameController.moveDisk(2);
                _updateDiskMoved(moveDisk);
                _gameController.eventControllerPin2
                    .firePinChangedEvent(moveDisk.disksSecondPin());
              } on ArgumentError catch(e) {
                _talkToPlayer(e.message);
              } on StateError catch(e) {
                _talkToPlayer(e.message);
              }
             },
            child: _uiSecondPin,
          )
      ),
      Flexible(
          flex: 2,
          child:InkWell(
              onTap: () async {
                try {
                  control.Progress moveDisk = await _gameController.moveDisk(3);
                  _updateDiskMoved(moveDisk);
                  _gameController.eventControllerPin3
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
              child: _uiThirdPin
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
      _uiDisk = ui_pin.Disk(progress.diskGrabbed, _gameController.eventControllerDisk);
      _uiFirstPin = ui_pin.Pin(key: UniqueKey(), initialPinDisks: progress.disksFirstPin(), pinEventController: _gameController.eventControllerPin1);
      _uiSecondPin = ui_pin.Pin(key: UniqueKey(), initialPinDisks: progress.disksSecondPin(), pinEventController: _gameController.eventControllerPin2);
      _uiThirdPin = ui_pin.Pin(key: UniqueKey(), initialPinDisks: progress.disksThirdPin(), pinEventController: _gameController.eventControllerPin3);
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
