import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:martian_robots/common/enums.dart';
import 'package:martian_robots/common/robot_colors.dart';
import 'package:martian_robots/model/appModel.dart';
import 'package:martian_robots/model/robot_model.dart';
import 'package:martian_robots/ui/gps_screen.dart';
import 'package:martian_robots/widget/text_form_field.dart';

class ConfigurationPage extends StatefulWidget {
  @override
  _ConfigurationPageState createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  ///MAP - PARAMS///

  FocusNode mapX = FocusNode();
  FocusNode mapY = FocusNode();

  TextEditingController _mapXController = TextEditingController();
  TextEditingController _mapYController = TextEditingController();

  late int finalMapX;
  late int finalMapY;

  /// ROBOTS - PARAMS///

  int? idRobotOne;
  int? idRobotTow;
  int? idRobotThree;

  FocusNode robotOneXFN = FocusNode();
  FocusNode robotOneYFN = FocusNode();

  TextEditingController _robotOneXController = TextEditingController();
  TextEditingController _robotOneYController = TextEditingController();

  int? coordinateRobotOneX;
  int? coordinateRobotOneY;

  FocusNode robotTowXFN = FocusNode();
  FocusNode robotTowYFN = FocusNode();

  TextEditingController _robotTowXController = TextEditingController();
  TextEditingController _robotTowYController = TextEditingController();

  int? coordinateRobotTowX;
  int? coordinateRobotTowY;

  FocusNode robotThreeXFN = FocusNode();
  FocusNode robotThreeYFN = FocusNode();

  TextEditingController _robotThreeXController = TextEditingController();
  TextEditingController _robotThreeYController = TextEditingController();

  int? coordinateRobotThreeX;
  int? coordinateRobotThreeY;

  bool tapButton1 = true;
  bool tapButton2 = false;
  bool tapButton3 = false;

  Map<String, dynamic>? colorOne;
  Map<String, dynamic>? colorTow;
  Map<String, dynamic>? colorThree;

  List<Map<String, dynamic>> listColors = [
    {"code": ColorsRobot.BLUE, "name": "Blue"},
    {"code": ColorsRobot.GREEN, "name": "Green"},
    {"code": ColorsRobot.YELLOW, "name": "Yellow"},
    {"code": ColorsRobot.WHITE, "name": "White"},
  ];

  Map<String, dynamic>? orientationOne;
  Map<String, dynamic>? orientationTow;
  Map<String, dynamic>? orientationThree;

  List<Map<String, dynamic>> listOrientation = [
    {"code": CardinalPoints.NORTH, "name": "N"},
    {"code": CardinalPoints.SOUTH, "name": "S"},
    {"code": CardinalPoints.EAST, "name": "E"},
    {"code": CardinalPoints.WEST, "name": "W"},
  ];

  final int buttonOneId = 1;
  final int buttonTowId = 2;
  final int buttonThreeId = 3;

  late int totalRobots = 1;

  ///FORM - PARAMS///
  final _formKey = GlobalKey<FormState>();
  List<bool> _noErrors = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Configuration Map & Robots"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            submitForm();
          },
          child: const Icon(Icons.send),
          backgroundColor: Colors.deepOrange,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              color: Colors.white54,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Center(
                        child: Text(
                      "Map Settings",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      textScaleFactor: 1,
                      style:
                          TextStyle(fontSize: 20.0, color: Colors.deepOrange),
                    )),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 100.0,
                          width: 150,
                          child: CustomTextFormField(
                            onChanged: (value) {},
                            key: Key('mapX'),
                            controller: _mapXController,
                            focusNode: mapX,
                            decoration: InputDecoration(
                              fillColor: Colors.deepOrangeAccent,
                              labelText: "map width",
                            ),
                            autocorrect: false,
                            validator: (val) => val.isEmpty
                                ? "required"
                                : int.parse(val) > 50
                                    ? "max 50"
                                    : int.parse(val) < 0
                                        ? "min 1"
                                        : null,
                            onSaved: (val) => finalMapX = int.parse(val),
                            onFieldSubmitted: (val) {
                              FocusScope.of(context).requestFocus(mapY);
                            },
                            keyboardType: TextInputType.number,
                            noErrorsCallback: (bool val) => _confirmErrors(val),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(2),
                            ],
                          ),
                        ),
                        Container(
                          height: 100.0,
                          width: 150,
                          child: CustomTextFormField(
                            onChanged: (value) {},
                            key: Key('mapY'),
                            controller: _mapYController,
                            focusNode: mapY,
                            decoration: InputDecoration(
                              fillColor: Colors.deepOrangeAccent,
                              labelText: "map height",
                            ),
                            autocorrect: false,
                            validator: (val) => val.isEmpty
                                ? "required"
                                : int.parse(val) > 50
                                    ? "max 50"
                                    : int.parse(val) < 0
                                        ? "min 1"
                                        : null,
                            onSaved: (val) => finalMapY = int.parse(val),
                            onFieldSubmitted: (val) {
                              FocusScope.of(context).requestFocus(null);
                            },
                            keyboardType: TextInputType.number,
                            noErrorsCallback: (bool val) => _confirmErrors(val),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(2),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Center(
                        child: Text(
                      "Robot Settings",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      textScaleFactor: 1,
                      style:
                          TextStyle(fontSize: 20.0, color: Colors.deepOrange),
                    )),
                    Divider(),
                    Row(
                      children: [
                        Text(
                          "Total Robot",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          textScaleFactor: 1,
                          style: TextStyle(
                              fontSize: 16.0, color: Colors.deepOrange),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        children: [
                          totalRobotButton(
                            buttonOneId,
                            tapButton1,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: totalRobotButton(
                              buttonTowId,
                              tapButton2,
                            ),
                          ),
                          totalRobotButton(
                            buttonThreeId,
                            tapButton3,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        children: [
                          Text(
                            "Color of robot",
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            textScaleFactor: 1,
                            style: TextStyle(
                                fontSize: 16.0, color: Colors.deepOrange),
                          ),
                        ],
                      ),
                    ),
                    Column(children: createDropdownColors()),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        children: [
                          Text(
                            "Coordinates of robots",
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            textScaleFactor: 1,
                            style: TextStyle(
                                fontSize: 16.0, color: Colors.deepOrange),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: createTexFields(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        children: [
                          Text(
                            "Orientation of robots",
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            textScaleFactor: 1,
                            style: TextStyle(
                                fontSize: 16.0, color: Colors.deepOrange),
                          ),
                        ],
                      ),
                    ),
                    Column(children: createDropdownCardinalPoints()),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  ///Robot Settings Methods///

  ///TOTAL ROBOTS///

  setTotalRobot(int input) {
    switch (input) {
      case 1:
        setState(() {
          tapButton1 = true;
          tapButton2 = false;
          tapButton3 = false;
          totalRobots = input;
        });
        break;
      case 2:
        setState(() {
          tapButton1 = false;
          tapButton2 = true;
          tapButton3 = false;
          totalRobots = input;
        });
        break;

      case 3:
        setState(() {
          tapButton1 = false;
          tapButton2 = false;
          tapButton3 = true;
          totalRobots = input;
        });
        break;
    }
  }

  Widget totalRobotButton(input, tap) {
    return FloatingActionButton(
      onPressed: () {
        _resetTextFocus();
        setTotalRobot(input);
      },
      backgroundColor: !tap ? Colors.deepOrange[300] : Colors.deepOrange,
      elevation: 0.5,
      splashColor: Colors.black54,
      child: Center(
        child: Text(
          input.toString(),
          textAlign: TextAlign.center,
          textScaleFactor: 1,
          style: TextStyle(fontSize: 30, color: Colors.white),
          overflow: TextOverflow.clip,
        ),
      ),
    );
  }

  ///COLOR OF ROBOTS///

  List<Widget> createDropdownColors() {
    List<Widget> result = [];
    List<Map<String, dynamic>?> colorsSelected = [
      colorOne,
      colorTow,
      colorThree
    ];
    for (var i = 0; i < totalRobots; i++) {
      result.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          children: [
            Icon(Icons.android,
                color: colorsSelected[i] != null &&
                        colorsSelected[i]!["code"] != ColorsRobot.WHITE
                    ? RobotColors().getColor(
                        colorsSelected[i]!["code"],
                      )
                    : Colors.black),
            Text(
              (i + 1).toString(),
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            Container(
              width: 100,
              child: DropdownButton<Map<String, dynamic>>(
                value: colorsSelected[i],
                isExpanded: true,
                underline: SizedBox(),
                isDense: true,
                onChanged: (Map<String, dynamic>? newValue) {
                  setState(() {
                    if (i == 0) {
                      colorOne = newValue;
                    } else if (i == 1) {
                      colorTow = newValue;
                    } else {
                      colorThree = newValue;
                    }
                  });
                },
                items: listColors.map((Map<String, dynamic> value) {
                  return DropdownMenuItem<Map<String, dynamic>>(
                    value: value,
                    child: Container(
                      color: RobotColors().getColor(value["code"]),
                      child: Text(
                        value['name'],
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ));
    }
    return result;
  }

  ///COORDINATES OF ROBOTS///

  List<Widget> createTexFields() {
    List<Widget> result = [];
    List<FocusNode> robotsXFocusNode = [
      robotOneXFN,
      robotTowXFN,
      robotThreeXFN,
    ];

    List<FocusNode> robotsYFocusNode = [
      robotOneYFN,
      robotTowYFN,
      robotThreeYFN
    ];

    List<TextEditingController> robotsXControllers = [
      _robotOneXController,
      _robotTowXController,
      _robotThreeXController,
    ];
    List<TextEditingController> robotsYControllers = [
      _robotOneYController,
      _robotTowYController,
      _robotThreeYController
    ];

    List<int?> finalCoordinatesRobotX = [
      coordinateRobotOneX,
      coordinateRobotTowX,
      coordinateRobotThreeX
    ];

    List<int?> finalCoordinatesRobotY = [
      coordinateRobotOneY,
      coordinateRobotTowY,
      coordinateRobotThreeY
    ];

    for (var i = 0; i < totalRobots; i++) {
      result.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 100.0,
            width: 150,
            child: CustomTextFormField(
              onChanged: (value) {},
              controller: robotsXControllers[i],
              focusNode: robotsXFocusNode[i],
              decoration: InputDecoration(
                fillColor: Colors.deepOrangeAccent,
                labelText: "Robot " + (i + 1).toString() + " X axis",
              ),
              autocorrect: false,
              validator: (val) {
                if (val.isEmpty) {
                  return "required";
                } else if (int.parse(val) > int.parse(_mapXController.text)) {
                  return "max" + _mapXController.text.toString();
                } else if (int.parse(val) <= 0) {
                  return "min 1";
                } else if (_checkCollusion()) {
                  return "collusion detected";
                } else {
                  return null;
                }
              },
              onSaved: (val) => finalCoordinatesRobotX[i] = int.parse(val),
              onFieldSubmitted: (val) {
                FocusScope.of(context).requestFocus(robotsYFocusNode[i]);
              },
              keyboardType: TextInputType.number,
              noErrorsCallback: (bool val) => _confirmErrors(val),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(2),
              ],
            ),
          ),
          Container(
            height: 100.0,
            width: 150,
            child: CustomTextFormField(
              controller: robotsYControllers[i],
              onChanged: (value) {},
              focusNode: robotsYFocusNode[i],
              decoration: InputDecoration(
                fillColor: Colors.deepOrangeAccent,
                labelText: "Robot " + (i + 1).toString() + " Y axis",
              ),
              autocorrect: false,
              validator: (val) {
                if (val.isEmpty) {
                  return "required";
                } else if (int.parse(val) > int.parse(_mapYController.text)) {
                  return "max" + _mapYController.text.toString();
                } else if (int.parse(val) <= 0) {
                  return "min 1";
                } else if (_checkCollusion()) {
                  return "collusion detected";
                } else {
                  return null;
                }
              },
              onSaved: (val) => finalCoordinatesRobotY[i] = int.parse(val),
              onFieldSubmitted: (val) {
                FocusScope.of(context).requestFocus(robotsXFocusNode[i + 1]);
              },
              keyboardType: TextInputType.number,
              noErrorsCallback: (bool val) => _confirmErrors(val),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(2),
              ],
            ),
          ),
        ],
      ));
    }
    return result;
  }

  _checkCollusion() {
    if ((_robotOneXController.text == _robotTowXController.text &&
            _robotOneYController.text == _robotTowYController.text) ||
        (_robotOneXController.text == _robotThreeXController.text &&
            _robotOneYController.text == _robotThreeYController.text) ||
        (_robotTowXController.text != '' &&
            _robotTowXController.text == _robotThreeXController.text &&
            _robotTowYController.text == _robotThreeYController.text)) {
      return true;
    }
    return false;
  }

  ///ORIENTATION OF ROBOTS///
  createDropdownCardinalPoints() {
    List<Widget> result = [];
    List<Map<String, dynamic>?> orientationsSelected = [
      orientationOne,
      orientationTow,
      orientationThree
    ];
    for (var i = 0; i < totalRobots; i++) {
      result.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          children: [
            Icon(Icons.visibility_outlined, color: Colors.black),
            Text(
              (i + 1).toString(),
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            Container(
              width: 100,
              child: DropdownButton<Map<String, dynamic>>(
                value: orientationsSelected[i],
                isExpanded: true,
                underline: SizedBox(),
                isDense: true,
                onChanged: (Map<String, dynamic>? newValue) {
                  setState(() {
                    if (i == 0) {
                      orientationOne = newValue;
                    } else if (i == 1) {
                      orientationTow = newValue;
                    } else {
                      orientationThree = newValue;
                    }
                  });
                  _resetTextFocus();
                },
                items: listOrientation.map((Map<String, dynamic> value) {
                  return DropdownMenuItem<Map<String, dynamic>>(
                    value: value,
                    child: Container(
                      child: Text(
                        value['name'],
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ));
    }
    return result;
  }

  ///FORM METHODS///

  _confirmErrors(bool state) {
    setState(() {
      _noErrors.add(state);
    });
  }

  _resetTextFocus() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  submitForm() {
    bool cancel = false;
    _resetTextFocus();
    if (_validateForm()) {
      List<Map<String, dynamic>?> colorsSelected = [
        colorOne,
        colorTow,
        colorThree
      ];

      List<TextEditingController> robotsXControllers = [
        _robotOneXController,
        _robotTowXController,
        _robotThreeXController,
      ];
      List<TextEditingController> robotsYControllers = [
        _robotOneYController,
        _robotTowYController,
        _robotThreeYController
      ];

      List<Map<String, dynamic>?> orientationsSelected = [
        orientationOne,
        orientationTow,
        orientationThree
      ];
      List<RobotModel> finalRobots = [];
      appModel.setMapCoordinates(finalMapX, finalMapY);
      for (var i = 0; i < totalRobots; i++) {
        if (robotsYControllers[i].text != "" &&
            robotsXControllers[i].text != "" &&
            orientationsSelected[i] != null &&
            colorsSelected[i] != null) {
          finalRobots.add(new RobotModel(
              int.parse(robotsYControllers[i].text),
              int.parse(robotsXControllers[i].text),
              orientationsSelected[i]!["code"],
              RobotColors().getColor(colorsSelected[i]!["code"]),
              true));
        } else {
          cancel = true;
          _showToast(context, "Check colors and orientation");
          break;
        }
      }
      if (!cancel) {
        appModel.setRobots(finalRobots);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => GpsScreen(
                      title: 'Manual - GPS',
                    )));
      }
    }
  }

  bool _validateForm() {
    final form = _formKey.currentState!;
    form.validate();
    if (!_noErrors.contains(false)) {
      setState(() {
        _noErrors = [];
      });
      form.save();
      return true;
    }
    setState(() {
      _noErrors = [];
    });
    return false;
  }

  void _showToast(BuildContext context, String text) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        backgroundColor: Colors.grey[400],
        elevation: 2.0,
        content: Text(
          text,
          style: TextStyle(color: Colors.black, fontSize: 16.0),
          textAlign: TextAlign.center,
          textScaleFactor: 1,
        ),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
