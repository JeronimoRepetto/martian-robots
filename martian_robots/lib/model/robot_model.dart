import 'dart:math';
import 'dart:ui';

import 'package:martian_robots/common/enums.dart';

class RobotModel {
  var _id = (Random().nextDouble() * DateTime.now().millisecond / 2).toStringAsFixed(9);
  get id => _id;
  late int _coordinateY;
  int get coordinateY => _coordinateY;
  late int _coordinateX;
  int get coordinateX => _coordinateX;
  late CardinalPoints _cardinalPoints;
  CardinalPoints get cardinalPoints => _cardinalPoints;
  late Color _robotColor;
  Color get robotColor => _robotColor;
  late bool _inLine;
  bool get inLine => _inLine;

  RobotModel(this._coordinateY, this._coordinateX, this._cardinalPoints,
      this._robotColor, this._inLine);

  setCardinalPoints(cardinalPoints) {
    this._cardinalPoints = cardinalPoints;
  }

  setCoordinateX(coordinateX) {
    this._coordinateX = coordinateX;
  }

  setInLine(inLine){
    this._inLine = inLine;
  }

  setCoordinateY(coordinateY) {
    this._coordinateY = coordinateY;
  }

  setRobotColor(robotColor) {
    this._robotColor = robotColor;
  }

  setId(id) {
    this._id = id;
  }

  String getCardinalPointsLetter() {
    switch (_cardinalPoints) {
      case CardinalPoints.NORTH:
        return "N";
      case CardinalPoints.SOUTH:
        return "S";
      case CardinalPoints.WEST:
        return "W";
      case CardinalPoints.EAST:
        return "E";
      default:
        return "";
    }
  }
}
