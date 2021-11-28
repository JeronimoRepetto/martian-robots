import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfigActionButton extends StatefulWidget {
  final input;
  final function;
  bool tap;
  ConfigActionButton({@required this.input, @required this.function, this.tap = false});

  @override
  _ConfigActionButtonState createState() => _ConfigActionButtonState();
}

class _ConfigActionButtonState extends State<ConfigActionButton> {
  late bool tap;

  @override
  void initState() {
    tap = widget.tap;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FloatingActionButton(
      onPressed: () {
        widget.function(widget.input);
      },
      backgroundColor: !tap ? Colors.deepOrange[300] : Colors.deepOrange,
      elevation: 0.5,
      splashColor: Colors.black54,
      child: Center(
        child: Text(
          widget.input.toString(),
          textAlign: TextAlign.center,
          textScaleFactor: 1,
          style: TextStyle(fontSize: 30, color: Colors.white),
          overflow: TextOverflow.clip,
        ),
      ),
    );
  }
}
