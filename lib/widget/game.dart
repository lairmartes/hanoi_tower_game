import 'package:eventify/eventify.dart';
import 'package:flutter/material.dart';
import 'package:hanoi_tower_control/hanoi_tower_control.dart' as control;
import 'package:hanoi_tower_game/events/events.dart';
import 'package:hanoi_tower_game/widget/pin.dart' as ui_pin;


class GameController {
  final PinEventController _eventControllerPin1 = PinEventController(EventEmitter());
  final PinEventController _eventControllerPin2 = PinEventController(EventEmitter());
  final PinEventController _eventControllerPin3 = PinEventController(EventEmitter());
  final DiskEventController _eventControllerDisk = DiskEventController(EventEmitter());

  final control.Game _game = control.Game();

  control.Progress _lastProgress;

  Future<control.Progress> startGame(int totalDisks) {

    return _game.start(totalDisks);
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
    return result;
  }

  Future<control.Progress> moveDisk(int pinPosition) {
    if (_lastProgress != null && _lastProgress.diskGrabbed != null) {
      return _dropDisk(pinPosition);
    } else {
      return _grabDisk(pinPosition);
    }
  }

  void updateLastProgress(control.Progress progress) {
    _lastProgress = progress;
  }

  PinEventController get eventControllerPin1 => _eventControllerPin1;

  PinEventController get eventControllerPin2 => _eventControllerPin2;

  PinEventController get eventControllerPin3 => _eventControllerPin3;

  DiskEventController get eventControllerDisk => _eventControllerDisk;

  control.Progress get lastProgress => _lastProgress;

  bool get isGameStarted => _lastProgress != null;
}


class Game extends StatefulWidget {

  final int initialDiskQuantity;

  const Game({Key key, this.initialDiskQuantity}) : super(key: key);

  @override
  _GameState createState() => _GameState(this.initialDiskQuantity);
}

class _GameState extends State<Game> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final GameController _gameController = GameController();
  final int _totalDisks;

  ui_pin.Disk _uiDisk;
  ui_pin.Pin _uiFirstPin;
  ui_pin.Pin _uiSecondPin;
  ui_pin.Pin _uiThirdPin;

  _GameState(this._totalDisks);

  @override
  void initState() {
    super.initState();

    if (!_gameController.isGameStarted) {
      _startGame(this._totalDisks);
    } else {
      _updateVisualElementsState(_gameController.lastProgress);
    }
  }

  void _startGame(int totalDisks) async {
    control.Progress startGame = await _gameController.startGame(totalDisks);
    _gameController.updateLastProgress(startGame);
    _updateVisualElementsState(startGame);
  }

  void _updateDiskMoved(control.Progress moveDisk) async {

    _updateVisualElementsState(moveDisk);

    _gameController.updateLastProgress(moveDisk);

    moveDisk.diskGrabbed == null
        ? _gameController.eventControllerDisk.fireDiskDropped()
        : _gameController.eventControllerDisk
            .fireDiskGrabbed(moveDisk.diskGrabbed);
  }

  _updateVisualElementsState(control.Progress progress) {
    _update(progress);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Scaffold(
          key: _scaffoldKey,
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
                } on ArgumentError catch(e) {
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
          duration: Duration(milliseconds: 500),
        )
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
}
