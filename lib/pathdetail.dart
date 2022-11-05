
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

int value = 1;
var screenheight = 0.0;
var screenwidth = 0.0;
class PathDetail extends StatefulWidget {

  @override
  _PathDetailState createState() => _PathDetailState();
}

class _PathDetailState extends State<PathDetail>{
  @override
  Widget build(BuildContext context) {
    screenheight = MediaQuery.of(context).size.height;
    screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Text("AAA")
    );
  }


}