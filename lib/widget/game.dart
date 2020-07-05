import 'package:eventify/eventify.dart';
import 'package:flutter/material.dart';
import 'package:hanoi_tower_control/hanoi_tower_control.dart' as control;
import 'package:hanoi_tower_game/events/events.dart';
import 'package:hanoi_tower_game/widget/pin.dart' as ui_pin;


class GameController {
  final PinEventController _eventControllerPin1 = PinEventController(EventEmitter());
  final PinEventController _eventControllerPin2 = PinEventController(EventEmitter());
  final PinEventController _eventControllerPin3 = PinEventController(EventEmitter());

  final DiskEventController _diskEventController = DiskEventController(EventEmitter());

  final GameEventController _gameEventController = GameEventController(EventEmitter());

  final control.Game _game = control.Game();

  GameModel _gameModel;

  bool _isGrabbing = true;
  control.Disk _currentDisk;

  Future<Game> createGame(int totalDisks) async {

     _gameModel = GameModel(_eventControllerPin1,
        _eventControllerPin2, _eventControllerPin3,
        _diskEventController, pinAction);

     control.Progress startGame = await _game.start(totalDisks);

     Game result = Game(_gameModel, startGame, _gameEventController);

     return result;
  }
  
  void _notifyUI(PinEventController pinEventController, 
      DiskEventController diskEventController, 
      control.PinDisks updatedPinDisk, 
      control.Disk updatedDisk) {
    pinEventController.firePinChangedEvent(updatedPinDisk);
    if (updatedDisk != null) {
      diskEventController.fireDiskGrabbed(updatedDisk);
    } else {
      diskEventController.fireDiskDropped();
    }
  }
  
  void _grabDisk(int pinPosition) async {
    PinEventController pinController;
    control.Progress progress;
    control.PinDisks pinDisks;

    try {
      switch (pinPosition) {
        case 1 :
          {
            pinController = _eventControllerPin1;
            progress = await _game.grabFromFirstPin();
            pinDisks = progress.disksFirstPin();
            break;
          }
        case 2 :
          {
            pinController = _eventControllerPin2;
            progress = await _game.grabFromSecondPin();
            pinDisks = progress.disksSecondPin();
            break;
          }
        case 3 :
          {
            pinController = _eventControllerPin3;
            progress = await _game.grabFromThirdPin();
            pinDisks = progress.disksThirdPin();
            break;
          }
      }
      _currentDisk = progress.diskGrabbed;
      _notifyUI(pinController, _diskEventController, pinDisks, _currentDisk);
      print('atualiza filho da puta!!!!');
      _gameEventController.fireGameProgressed(progress);
      _isGrabbing = false;
    } on ArgumentError catch(e) {
      print('Error detected: ${e.message}');
    }
  }

  void _dropDisk(int pinPosition) async {
    PinEventController pinController;
    control.Progress progress;
    control.PinDisks pinDisks;
    try {
      switch (pinPosition) {
        case 1 :
          {
            pinController = _eventControllerPin1;
            progress = await _game.dropDiskInFirstPin(_currentDisk);
            pinDisks = progress.disksFirstPin();
            break;
          }
        case 2 :
          {
            pinController = _eventControllerPin2;
            progress = await _game.dropDiskInSecondPin(_currentDisk);
            pinDisks = progress.disksSecondPin();
            break;
          }
        case 3 :
          {
            pinController = _eventControllerPin3;
            progress = await _game.dropDiskInThirdPin(_currentDisk);
            pinDisks = progress.disksThirdPin();
            break;
          }
      }
        _currentDisk = null;
        _notifyUI(pinController, _diskEventController, pinDisks, _currentDisk);
        _gameEventController.fireGameProgressed(progress);
        _isGrabbing = true;
    } on ArgumentError catch (e) {
      print('Error detected: ${e.message}');
    }
  }

  void pinAction(int pinPosition) {
    if (_isGrabbing) {
      _grabDisk(pinPosition);
    } else {
      _dropDisk(pinPosition);
    }
  }
}

class GameModel {
  final PinEventController pin1EventController;
  final PinEventController pin2EventController;
  final PinEventController pin3EventController;

  final DiskEventController diskEventController;

  final Function pinActionCallBack;

  GameModel(this.pin1EventController, this.pin2EventController,
      this.pin3EventController, this.diskEventController,
      this.pinActionCallBack);
}

class Game extends StatefulWidget {

  final GameModel _gameModel;
  final control.Progress _initialProgress;
  final GameEventController _gameEventController;

  Game(this._gameModel, this._initialProgress, this._gameEventController);

  @override
  _GameState createState() => _GameState(this._gameModel,
      this._gameEventController,
      this._initialProgress);
}

class _GameState extends State<Game> {

  final GameModel _gameModel;

  final GameEventController _gameEventController;

  control.Progress _currentProgress;

  ui_pin.Disk _uiDisk;
  ui_pin.Pin _uiFirstPin;
  ui_pin.Pin _uiSecondPin;
  ui_pin.Pin _uiThirdPin;

  Function _pinActionCallBack;

  _GameState(this._gameModel, this._gameEventController, this._currentProgress);

  @override
  void initState() {
    super.initState();

    print("Have you already passed here?");

    _uiDisk = ui_pin.Disk(_currentProgress.diskGrabbed, _gameModel.diskEventController);
    _uiFirstPin = ui_pin.Pin(_currentProgress.disksFirstPin(), _gameModel.pin1EventController);
    _uiSecondPin = ui_pin.Pin(_currentProgress.disksSecondPin(), _gameModel.pin2EventController);
    _uiThirdPin = ui_pin.Pin(_currentProgress.disksThirdPin(), _gameModel.pin3EventController);
    _pinActionCallBack = _gameModel.pinActionCallBack;

    _gameEventController.addGameEventListener(this, (ev, context) {
      print('adicionaou o ouvinte filho da puta???');
      _update(ev.eventData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Scaffold(
          body: Column(
            children: <Widget>[
              Flexible(
                flex: 2,
                child: _uiDisk,
              ),
              Flexible(
                  flex: 20,
                  child:_createPinsWithOrientation(context, this._pinActionCallBack)
              )
            ],
          )
      ),
    );
  }

  Flex _createPinsWithOrientation(BuildContext context, Function pinActionCallBack) {
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
              onTap: () {
                _pinActionCallBack(1);
              },
              child: _uiFirstPin
          )
      ),
      Flexible(
          flex: 2,
          child:InkWell(
            onTap: () {
              _pinActionCallBack(2);
            },
            child: _uiSecondPin,
          )
      ),
      Flexible(
          flex: 2,
          child:InkWell(
              onTap: () {
                _pinActionCallBack(3);
              },
              child: _uiThirdPin
          )
      ),
    ];
  }

  void _update(control.Progress progress) {
    setState(() {
      _currentProgress = progress;
      print("Progresso atualizado no estado... ${_currentProgress.disksFirstPin().disks.length}");
      _uiDisk = ui_pin.Disk(_currentProgress.diskGrabbed, _gameModel.diskEventController);
      _uiFirstPin = ui_pin.Pin(_currentProgress.disksFirstPin(), _gameModel.pin1EventController);
      _uiSecondPin = ui_pin.Pin(_currentProgress.disksSecondPin(), _gameModel.pin2EventController);
      _uiThirdPin = ui_pin.Pin(_currentProgress.disksThirdPin(), _gameModel.pin3EventController);
    });
  }
}
