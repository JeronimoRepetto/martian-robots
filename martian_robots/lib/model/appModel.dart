import 'package:martian_robots/model/robot_model.dart';

final AppModel appModel = AppModel();

class AppModel {
  List<RobotModel>? _robots;
  List<RobotModel>? get robots => _robots;
  int? _coordinateMapX;
  int? get coordinateMapX => _coordinateMapX;
  int? _coordinateMapY;
  int? get coordinateMapY => _coordinateMapY;
  List<RobotModel?> _lastConnections = [];
  List<RobotModel?> get lastConnections => _lastConnections;

  RobotModel? _robotSelected;
  RobotModel? get robotSelected => _robotSelected;

  setRobots(List<RobotModel> robots) {
    _robots = robots;
  }

  setMapCoordinates(int x, int y) {
    _coordinateMapX = x;
    _coordinateMapY = y;
  }

  setRobotSelected(RobotModel robotSelected) {
    _robotSelected = robotSelected;
  }

  setLastConnection(lastConnection) {
    this._lastConnections.add(lastConnection);
  }

  cleanData() {
    _robots = null;
    _coordinateMapX = null;
    _coordinateMapY = null;
    _robotSelected = null;
    _lastConnections = [];
  }
}
