import 'dart:math';
import 'dart:ui';

import 'package:martian_robots/common/enums.dart';
import 'package:martian_robots/common/robot_colors.dart';
import 'package:martian_robots/model/appModel.dart';
import 'package:martian_robots/model/robot_model.dart';
import 'package:flutter/material.dart';

class GpsController {
  GpsController(this.cleanRobotSelection);
  late int mapX;
  late int mapY;
  List<RobotModel> robot = [];
  String logs = "";
  VoidCallback cleanRobotSelection;

  //Map Method

  createRandomSizeMap() {
    if (appModel.coordinateMapX == null) {
      Random rng = new Random();
      mapX = rng.nextInt(50) + 2;
      mapY = rng.nextInt(50) + 2;
      print("Mapa: (" + mapX.toString() + "," + mapY.toString() + ")");
    } else {
      mapX = appModel.coordinateMapX!;
      mapY = appModel.coordinateMapY!;
    }
  }

  //Robot Methods
  createRandomRobot() {
    if (appModel.robots == null) {
      Random rng = new Random();
      robot.add(new RobotModel(
          rng.nextInt(mapY - 1) + 1,
          rng.nextInt(mapX - 1) + 1,
          CardinalPoints.values[rng.nextInt(CardinalPoints.values.length)],
          RobotColors.green,
          true));
    } else {
      robot = appModel.robots!;
    }
  }

  //Actions Methods
  executeOrder(String inputSelected, robotId) {
    var inputs = inputSelected.characters;
    RobotModel finalRobot =
        robot.where((element) => element.id == robotId).first;
    appModel.setRobotSelected(finalRobot);
    inputs.forEach((inputActuion) {
      if (inputActuion == "F") {
        _forward(finalRobot);
      } else {
        _changeCardinalPoints(inputActuion, finalRobot);
      }
    });
    logs = _createLogs(finalRobot, inputSelected);
  }

  //Here I check if the coordinates of the robot selected is out of map
  bool _checkLine(RobotModel finalRobot) {
    if (finalRobot.coordinateX < 1 ||
        finalRobot.coordinateX > mapX ||
        finalRobot.coordinateY < 1 ||
        finalRobot.coordinateY > mapY) {
      appModel.robotSelected!.setInLine(false);
      cleanRobotSelection();
      return false;
    }
    return true;
  }

  String _createLogs(RobotModel finalRobot, String inputSelected) {
    String principalText = '';
    String secondaryText = '';
    for (var i = 0; i < robot.length; i++) {
      if (finalRobot.id == robot[i].id) {
        if (finalRobot.inLine) {
          principalText = "ROBOT SELECTED:" +
              "\n" +
              "R-" +
              finalRobot.id.toString() +
              "\n" +
              "INPUT:" +
              "\n" +
              inputSelected +
              "\n" +
              "FINAL POSITION:" +
              "\n" +
              finalRobot.coordinateX.toString() +
              " " +
              finalRobot.coordinateY.toString() +
              " " +
              finalRobot.getCardinalPointsLetter() +
              "\n";
        } else {
          RobotModel robotDead = appModel.lastConnections
              .where((element) => element!.id == finalRobot.id)
              .first!;
          principalText = "ROBOT SELECTED:" +
              "\n" +
              "R-" +
              robotDead.id.toString() +
              "\n" +
              "INPUT:" +
              "\n" +
              inputSelected +
              "\n" +
              "FINAL POSITION:" +
              "\n" +
              robotDead.coordinateX.toString() +
              " " +
              robotDead.coordinateY.toString() +
              " " +
              robotDead.getCardinalPointsLetter() +
              " LOST" +
              "\n";
        }
      } else {
        if (robot[i].inLine) {
          secondaryText = secondaryText +
              "ROBOT:" +
              "\n" +
              "R-" +
              robot[i].id.toString() +
              "\n" +
              "POSITION: " +
              "\n" +
              robot[i].coordinateX.toString() +
              " " +
              robot[i].coordinateY.toString() +
              " " +
              robot[i].getCardinalPointsLetter() +
              "\n";
        } else {
          RobotModel robotDead = appModel.lastConnections
              .where((element) => element!.id == robot[i].id)
              .first!;
          secondaryText = secondaryText +
              "ROBOT:" +
              "\n" +
              "R-" +
              robotDead.id.toString() +
              "\n" +
              "POSITION: " +
              "\n" +
              robotDead.coordinateX.toString() +
              " " +
              robotDead.coordinateY.toString() +
              " " +
              robotDead.getCardinalPointsLetter() +
              (robotDead.inLine ? "" : " LOST") +
              "\n";
        }
      }
    }
    return principalText + secondaryText;
  }

  //Here i change the orientation of robot selected
  _changeCardinalPoints(action, finalRobot) {
    switch (finalRobot.cardinalPoints) {
      case CardinalPoints.NORTH:
        if (action == "L") {
          finalRobot.setCardinalPoints(CardinalPoints.WEST);
        } else {
          finalRobot.setCardinalPoints(CardinalPoints.EAST);
        }
        break;
      case CardinalPoints.SOUTH:
        if (action == "L") {
          finalRobot.setCardinalPoints(CardinalPoints.EAST);
        } else {
          finalRobot.setCardinalPoints(CardinalPoints.WEST);
        }
        break;
      case CardinalPoints.WEST:
        if (action == "L") {
          finalRobot.setCardinalPoints(CardinalPoints.SOUTH);
        } else {
          finalRobot.setCardinalPoints(CardinalPoints.NORTH);
        }
        break;
      case CardinalPoints.EAST:
        if (action == "L") {
          finalRobot.setCardinalPoints(CardinalPoints.NORTH);
        } else {
          finalRobot.setCardinalPoints(CardinalPoints.SOUTH);
        }
        break;
      default:
        break;
    }
  }

  //Here i check if other robot cross here and if it disappeared or not
  //If it disappeared, the selected robot doesn't go forward
  bool _checkDeadLine(RobotModel finalRobot) {
    int error = 0;
    if (appModel.lastConnections.isNotEmpty) {
      appModel.lastConnections.forEach((element) {
        if (finalRobot.coordinateX == element!.coordinateX &&
            finalRobot.coordinateY == element.coordinateY &&
            finalRobot.cardinalPoints == element.cardinalPoints) {
          error++;
        }
      });
      if (error != 0) {
        return true;
      }
    }
    return false;
  }

  _forward(RobotModel finalRobot) {
    switch (finalRobot.cardinalPoints) {
      case CardinalPoints.NORTH:
        if (!_checkDeadLine(finalRobot)) {
          finalRobot.setCoordinateY(finalRobot.coordinateY + 1);
          if (!_checkLine(finalRobot)) {
            finalRobot.setInLine(false);
            RobotModel deadRobot = new RobotModel(
                finalRobot.coordinateY,
                finalRobot.coordinateX,
                finalRobot.cardinalPoints,
                finalRobot.robotColor,
                finalRobot.inLine);
            deadRobot.setId(finalRobot.id);
            appModel.setLastConnection(deadRobot);
            appModel.lastConnections.last!
                .setCoordinateY(deadRobot.coordinateY - 1);
          }
        }
        break;
      case CardinalPoints.SOUTH:
        if (!_checkDeadLine(finalRobot)) {
          finalRobot.setCoordinateY(finalRobot.coordinateY - 1);
          if (!_checkLine(finalRobot)) {
            finalRobot.setInLine(false);
            RobotModel deadRobot = new RobotModel(
                finalRobot.coordinateY,
                finalRobot.coordinateX,
                finalRobot.cardinalPoints,
                finalRobot.robotColor,
                finalRobot.inLine);
            deadRobot.setId(finalRobot.id);
            appModel.setLastConnection(deadRobot);
            appModel.lastConnections.last!
                .setCoordinateY(deadRobot.coordinateY + 1);
          }
        }
        break;
      case CardinalPoints.WEST:
        if (!_checkDeadLine(finalRobot)) {
          finalRobot.setCoordinateX(finalRobot.coordinateX - 1);
          if (!_checkLine(finalRobot)) {
            finalRobot.setInLine(false);
            RobotModel deadRobot = new RobotModel(
                finalRobot.coordinateY,
                finalRobot.coordinateX,
                finalRobot.cardinalPoints,
                finalRobot.robotColor,
                finalRobot.inLine);
            deadRobot.setId(finalRobot.id);
            appModel.setLastConnection(deadRobot);
            appModel.lastConnections.last!
                .setCoordinateX(deadRobot.coordinateX + 1);
          }
        }
        break;
      case CardinalPoints.EAST:
        if (!_checkDeadLine(finalRobot)) {
          finalRobot.setCoordinateX(finalRobot.coordinateX + 1);
          if (!_checkLine(finalRobot)) {
            finalRobot.setInLine(false);
            finalRobot.setInLine(false);
            RobotModel deadRobot = new RobotModel(
                finalRobot.coordinateY,
                finalRobot.coordinateX,
                finalRobot.cardinalPoints,
                finalRobot.robotColor,
                finalRobot.inLine);
            deadRobot.setId(finalRobot.id);
            appModel.setLastConnection(deadRobot);
            appModel.lastConnections.last!
                .setCoordinateX(deadRobot.coordinateX - 1);
          }
        }
        break;
      default:
        break;
    }
  }

  String executeLogs() {
    return logs;
  }
}
