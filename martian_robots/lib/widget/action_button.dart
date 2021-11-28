import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final input;
  final function;
  var activate;
  ActionButton({@required this.input, @required this.function, @required this.activate});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FloatingActionButton(
      onPressed: activate ? () => function(input) : (){},
      elevation: 0.5,
      splashColor: Colors.black54,
      backgroundColor: activate ? Colors.deepOrangeAccent : Colors.grey,
      child: Center(
        child: Text(
          input,
          textAlign: TextAlign.center,
          textScaleFactor: 1,
          style: TextStyle(fontSize: 30, color: Colors.white),
          overflow: TextOverflow.clip,
        ),
      ),
    );
  }
}
