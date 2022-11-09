
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

int value = 1;
var screenheight = 0.0;
var screenwidth = 0.0;
class PathDesc extends StatefulWidget {

  @override
  _PathDescState createState() => _PathDescState();
}

class _PathDescState extends State<PathDesc>{
  @override
  Widget build(BuildContext context) {
    screenheight = MediaQuery.of(context).size.height;
    screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Text("AAA")
    );
  }


}