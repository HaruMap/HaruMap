import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harumap2/selectcase.dart';

class StartPage extends StatefulWidget {
  
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage>{
  @override
  void initState() {
    Timer(Duration(seconds: 3),(){
      Get.offAll(SelectCasePage());
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      body: Center(
        child: Container(
          height: 110,
          width: 110,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Color.fromARGB(200, 232, 232, 232),
            shape: BoxShape.circle
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text("하루",
                style: TextStyle(fontSize: 23,fontFamily: "NanumSquare"),
                textScaleFactor: 1.0,
                overflow: TextOverflow.ellipsis,
                ),
              Text("",style: TextStyle(fontSize: 5),),
              Text("지도",
                style: TextStyle(fontSize: 23,fontFamily: "NanumSquare"),
                textScaleFactor: 1.0,
                overflow: TextOverflow.ellipsis,
              ),
            ]
          )
        ),
      ),
    );

  }
}