import 'package:flutter/material.dart';

import 'enums.dart';

class RobotColors {
  static final Color green = Colors.green;
  static final Color yellow = Colors.yellow;
  static final Color white = Colors.white;
  static final Color blue = Colors.blue;

  static final List<Color> colorsList = [green, yellow, white, blue];

  getColor(colorCode) {
    switch (colorCode) {
      case ColorsRobot.YELLOW:
        return yellow;
      case ColorsRobot.GREEN:
        return green;
      case ColorsRobot.BLUE:
        return blue;
      case ColorsRobot.WHITE:
        return white;
      default:
        return Colors.black;
    }
  }
}
