import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:martian_robots/common/enums.dart';
import 'package:martian_robots/controller/gps_controller.dart';
import 'package:martian_robots/model/robot_model.dart';
import 'package:martian_robots/widget/action_button.dart';

class GpsScreen extends StatefulWidget {
  GpsScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _GpsScreenState createState() => _GpsScreenState();
}

class _GpsScreenState extends State<GpsScreen> {
  String inputSelected = '';
  late GpsController _gpsController;
  var _idRobotSelected;
  bool scrolling = false;
  @override
  void initState() {
    _gpsController = new GpsController(cleanRobotSelection);
    _gpsController.createRandomSizeMap();
    _gpsController.createRandomRobot();
    super.initState();

    SchedulerBinding.instance!.addPostFrameCallback((_) => {_checkMapSize()});
  }

  bool _checkInputLength() {
    if (inputSelected.length >= 100) {
      _showToast(context, 'Max characters 100');
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Container(
              decoration: BoxDecoration(color: Colors.black),
              width: MediaQuery.of(context).size.width,
              child: Text(
                "Select a robot",
                style: TextStyle(fontSize: 20.0, color: Colors.white54),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                textScaleFactor: 1,
              )),
          Divider(
            height: 0.25,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Colors.black),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: _listRobotSelections(),
              ),
            ),
          ),
          Divider(
            height: 0.25,
          ),
          Expanded(
            flex: 2,
            child: Container(
                decoration: BoxDecoration(color: Colors.black),
                child: Center(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _mapCreator(),
                ))),
          ),
          Expanded(
            flex: 1,
            child: Stack(
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          color: Colors.blueGrey,
                          width: MediaQuery.of(context).size.width / 3,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              'Explore-LOG',
                              style: TextStyle(
                                  color: Colors.grey[300], fontSize: 16),
                              textScaleFactor: 1,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Expanded(
                          child: NotificationListener<ScrollNotification>(
                            onNotification: (scrollNotification) {
                              if (scrollNotification
                                  is ScrollStartNotification) {
                                setState(() {
                                  scrolling = true;
                                });
                                return true;
                              } else if (scrollNotification
                                  is ScrollUpdateNotification) {
                                setState(() {
                                  scrolling = true;
                                });
                                return true;
                              } else if (scrollNotification
                                  is ScrollEndNotification) {
                                setState(() {
                                  scrolling = false;
                                });
                                return true;
                              } else {
                                return false;
                              }
                            },
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                    color: Colors.grey[300],
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(
                                        _gpsController.executeLogs(),
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 13),
                                        textScaleFactor: 1,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    color: Colors.grey[300],
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    height: 50.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        color: Colors.blueGrey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Center(
                                child: ActionButton(
                              input: checkInput(Inputs.FORWARD),
                              function: _chargeInput,
                              activate: _idRobotSelected != null,
                            )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30.0),
                                  child: ActionButton(
                                    input: checkInput(Inputs.LEFT),
                                    function: _chargeInput,
                                    activate: _idRobotSelected != null,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30.0),
                                  child: ActionButton(
                                    input: checkInput(Inputs.RIGHT),
                                    function: _chargeInput,
                                    activate: _idRobotSelected != null,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Positioned(
                  bottom: 0.0,
                  right: 0.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AnimatedContainer(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey)),
                        height: 50.0,
                        width: scrolling
                            ? MediaQuery.of(context).size.width / 2
                            : MediaQuery.of(context).size.width - 50.0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 4.0),
                        duration: Duration(milliseconds: 250),
                        child: Text(
                          inputSelected,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                              fontStyle: FontStyle.normal),
                        ),
                      ),
                      InkWell(
                        onTap: inputSelected.length == 0
                            ? () {}
                            : () {
                                setState(() {
                                  _gpsController.executeOrder(
                                      inputSelected, _idRobotSelected);
                                  inputSelected = '';
                                });
                              },
                        child: Container(
                          decoration: BoxDecoration(
                              color: inputSelected.length == 0
                                  ? Colors.deepOrange[200]
                                  : Colors.deepOrange,
                              border: Border.all(color: Colors.grey)),
                          height: 50,
                          width: 50,
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _listRobotSelections() {
    List<Widget> finalList = [];
    _gpsController.robot.forEach((element) {
      finalList.add(Padding(
        padding: const EdgeInsets.all(0.1),
        child: InkWell(
          onTap: element.inLine
              ? () {
                  setState(() {
                    _idRobotSelected = element.id;
                  });
                }
              : () {},
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white54),
              color: _idRobotSelected == element.id && element.inLine
                  ? Colors.deepOrange[600]
                  : Colors.black,
            ),
            height: 50,
            width: 50,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(element.getCardinalPointsLetter(),
                        style: TextStyle(color: Colors.black, fontSize: 15.0),
                        textScaleFactor: 1,
                        textAlign: TextAlign.center)
                  ],
                ),
                Center(
                  child: Icon(
                    element.inLine ? Icons.android : Icons.wifi_off_sharp,
                    color: element.inLine ? element.robotColor : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      ));
    });
    finalList.add(Expanded(
      child: Container(
        child: Text(
          "Map Format : (" +
              _gpsController.mapX.toString() +
              "," +
              _gpsController.mapY.toString() +
              ")",
          textAlign: TextAlign.end,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    ));
    return finalList;
  }

  List<Widget> _mapCreator() {
    List<Widget> finalMap = [];
    List<Widget> containers = [];
    for (int i = _gpsController.mapY; i != 0; i--) {
      for (int f = 1; f < _gpsController.mapX + 1; f++) {
        var idRobot = _robotDetected(i, f);
        if (idRobot != null) {
          RobotModel robotDetected = _getRobot(idRobot);
          containers.insert(
              containers.length,
              Padding(
                padding: const EdgeInsets.all(0.1),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _idRobotSelected = idRobot;
                    });
                  },
                  child: Container(
                    height: _generateSize(),
                    width: _generateSize(),
                    color: _gpsController.mapX > 10 || _gpsController.mapY > 10
                        ? robotDetected.robotColor
                        : Colors.deepOrange[600],
                    child: _gpsController.mapX > 10 || _gpsController.mapY > 10
                        ? SizedBox()
                        : Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(robotDetected.getCardinalPointsLetter(),
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 10.0),
                                      textScaleFactor: 1,
                                      textAlign: TextAlign.center)
                                ],
                              ),
                              Center(
                                child: Icon(
                                  Icons.android,
                                  color: robotDetected.robotColor,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ));
        } else {
          containers.insert(
              containers.length,
              Padding(
                padding: const EdgeInsets.all(0.1),
                child: Container(
                  color: Colors.deepOrangeAccent,
                  height: _generateSize(),
                  width: _generateSize(),
                ),
              ));
        }
      }
      finalMap.insert(
          finalMap.length,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: containers,
          ));
      containers = [];
    }
    return finalMap;
  }

  cleanRobotSelection() {
    setState(() {
      _idRobotSelected = null;
    });
  }

  dynamic _robotDetected(i, f) {
    for (var d = 0; d < _gpsController.robot.length; d++) {
      if (i == _gpsController.robot[d].coordinateY &&
          f == _gpsController.robot[d].coordinateX) {
        return _gpsController.robot[d].id;
      }
    }
    return null;
  }

  RobotModel _getRobot(idRobot) {
    return _gpsController.robot.where((element) => element.id == idRobot).first;
  }

  String checkInput(input) {
    switch (input) {
      case Inputs.FORWARD:
        return "F";
      case Inputs.LEFT:
        return "L";
      case Inputs.RIGHT:
        return "R";
      default:
        return "";
    }
  }

  _chargeInput(String input) {
    if (_checkInputLength())
      setState(() {
        inputSelected = inputSelected + input;
      });
  }

  double _generateSize() {
    if (_gpsController.mapY > _gpsController.mapX) {
      return (MediaQuery.of(context).size.height / 2) /
          (_gpsController.mapY * 1.2);
    } else {
      return (MediaQuery.of(context).size.width) / (_gpsController.mapX * 1.2);
    }
  }

  _checkMapSize() {
    if (_gpsController.mapX > 10 || _gpsController.mapY > 10) {
      _showToast(context, "Map format was modified for better view");
    }
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
