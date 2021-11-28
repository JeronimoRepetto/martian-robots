import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:martian_robots/model/appModel.dart';
import 'package:martian_robots/ui/configutation_page.dart';
import 'package:martian_robots/ui/gps_screen.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Center(
          child: Text('Martian Robots',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 20.0),
              overflow: TextOverflow.ellipsis,
              textScaleFactor: 1),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Center(
            child: Container(
              height: 200,
              width: 210,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: new AssetImage("assets/explore_mars.jpg"),
                    fit: BoxFit.fill),
                borderRadius: BorderRadius.circular(100.0),
                color: Colors.orange,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  IconButton(
                    key: key,
                    onPressed: () {
                      appModel.cleanData();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GpsScreen(
                                    title: 'Random - GPS',
                                  )));
                    },
                    splashColor: Colors.deepOrange,
                    icon: Icon(
                      Icons.add_to_queue_outlined,
                      color: Colors.deepOrangeAccent,
                    ),
                    iconSize: 80.0,
                  ),
                  Center(
                      child: Text(
                    "Random",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    textScaleFactor: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ))
                ],
              ),
              Column(
                children: [
                  IconButton(
                    key: key,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ConfigurationPage()));
                    },
                    icon: Icon(
                      Icons.build,
                      color: Colors.deepOrangeAccent,
                      size: 50.0,
                    ),
                    iconSize: 80.0,
                  ),
                  Center(
                      child: Text(
                    "Settings",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    textScaleFactor: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ))
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
