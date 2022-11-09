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
      backgroundColor: Color.fromARGB(233, 104, 231, 205),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("편안한 하루를 안내하는",
                      style: TextStyle(fontSize: 23,color: Colors.white,fontFamily: "NotoSans"),
                      textScaleFactor: 1.0,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text("",style: TextStyle(fontSize: 10),),
                    Text("하루 지도",
                      style: TextStyle(fontSize: 40,color: Colors.white,fontFamily: "NotoSans",fontWeight: FontWeight.bold),
                      textScaleFactor: 1.0,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

            ]
          )
        ),
      ),
    );

  }
}