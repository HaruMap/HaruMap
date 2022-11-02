import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:harumap2/mainpage.dart';

class SelectCasePage extends StatefulWidget{

  @override
  _SelectCaseState createState() => _SelectCaseState();

}

class _SelectCaseState extends State<SelectCasePage>{
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    var screenheight = MediaQuery.of(context).size.height;
    var screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("유형을 선택해주세요",
          style: TextStyle(fontSize: screenwidth*0.05,fontFamily: "NanumSquare",color: Colors.black),
          textScaleFactor: 1.0,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                      Get.to(MainPage());
                    },
                    child: Container(
                      height: screenwidth*0.4,
                      width: screenwidth*0.4,
                      margin: EdgeInsets.fromLTRB(20, 10, 10, 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 7,
                            offset: Offset(1,3),
                          )
                        ],
                        borderRadius: BorderRadius.circular(screenwidth*0.08),

                      ),
                      child: Column(
                          children: [
                            IconButton(
                              icon: Icon(Icons.wheelchair_pickup),
                              color: Color.fromARGB(200, 135, 134, 134),
                              iconSize: screenwidth*0.2,
                              onPressed: (){
                                Get.to(MainPage());
                              },
                            ),
                            Text("휠체어를 타고",
                              style: TextStyle(fontSize: screenwidth*0.045,fontFamily: "NanumSquare"),
                              textScaleFactor: 1.0,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text("", style: TextStyle(fontSize: 3),),
                            Text("계신가요?",
                              style: TextStyle(fontSize: screenwidth*0.045,fontFamily: "NanumSquare"),
                              textScaleFactor: 1.0,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ]
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Get.to(MainPage());
                    },
                    child: Container(
                      height: screenwidth*0.4,
                      width: screenwidth*0.4,
                      margin: EdgeInsets.fromLTRB(10, 10, 20, 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 7,
                            offset: Offset(1,3),
                          )
                        ],
                        borderRadius: BorderRadius.circular(screenwidth*0.08),

                      ),
                      child: Column(
                          children: [
                            IconButton(
                              icon: Icon(Icons.stroller),
                              color: Color.fromARGB(200, 135, 134, 134),
                              iconSize: screenwidth*0.2,
                              onPressed: (){
                                Get.to(MainPage());
                              },
                            ),
                            Text("유모차를 가지고",
                              style: TextStyle(fontSize: screenwidth*0.045, fontFamily: "NanumSquare"),
                              textScaleFactor: 1.0,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text("", style: TextStyle(fontSize: 3),),
                            Text("계신가요?",
                              style: TextStyle(fontSize: screenwidth*0.045,fontFamily: "NanumSquare"),
                              textScaleFactor: 1.0,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ]
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                      Get.to(MainPage());
                    },
                    child: Container(
                      height: screenwidth*0.4,
                      width: screenwidth*0.4,
                      margin: EdgeInsets.fromLTRB(20, 10, 10, 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 7,
                            offset: Offset(1,3),
                          )
                        ],
                        borderRadius: BorderRadius.circular(screenwidth*0.08),

                      ),
                      child: Column(
                          children: [
                            IconButton(
                              icon: Icon(Icons.emoji_people),
                              color: Color.fromARGB(200, 135, 134, 134),
                              iconSize: screenwidth*0.2,
                              onPressed: (){
                                Get.to(MainPage());
                              },
                            ),
                            Text("다리를",
                              style: TextStyle(fontSize: screenwidth*0.045,fontFamily: "NanumSquare"),
                              textScaleFactor: 1.0,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text("", style: TextStyle(fontSize: 3),),
                            Text("다치셨나요?",
                              style: TextStyle(fontSize: screenwidth*0.045,fontFamily: "NanumSquare"),
                              textScaleFactor: 1.0,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ]
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Get.to(MainPage());
                    },
                  child: Container(
                    height: screenwidth*0.4,
                    width: screenwidth*0.4,
                    margin: EdgeInsets.fromLTRB(10, 10, 20, 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: Offset(1,3),
                        )
                      ],
                      borderRadius: BorderRadius.circular(screenwidth*0.08),

                    ),
                    child: Column(
                        children: [
                          IconButton(
                            icon: Icon(Icons.pregnant_woman),
                            color: Color.fromARGB(200, 135, 134, 134),
                            iconSize: screenwidth*0.2,
                            onPressed: (){
                              Get.to(MainPage());
                            },
                          ),
                          Text("임산부",
                            style: TextStyle(fontSize: screenwidth*0.045,fontFamily: "NanumSquare"),
                            textScaleFactor: 1.0,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text("", style: TextStyle(fontSize: 3),),
                          Text("이신가요?",
                            style: TextStyle(fontSize: screenwidth*0.045,fontFamily: "NanumSquare"),
                            textScaleFactor: 1.0,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ]
                    ),
                  ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                      Get.to(MainPage());
                    },
                    child: Container(
                      height: screenwidth*0.4,
                      width: screenwidth*0.85,
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 7,
                            offset: Offset(1,3),
                          )
                        ],
                        borderRadius: BorderRadius.circular(screenwidth*0.08),

                      ),
                      child: Column(
                          children: [
                            IconButton(
                              icon: Icon(Icons.elderly),
                              color: Color.fromARGB(200, 135, 134, 134),
                              iconSize: screenwidth*0.25,
                              onPressed: (){
                                Get.to(MainPage());
                              },
                            ),
                            Text("노약자 이신가요?",
                              style: TextStyle(fontSize: screenwidth*0.06,fontFamily: "NanumSquare"),
                              textScaleFactor: 1.0,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ]
                      ),
                    ),
                  ),
                ],
              ),
          ]
        ),
      )
    );
  }
}