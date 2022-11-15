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
      backgroundColor: Color.fromARGB(255, 245, 245, 245),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text("하루 지도",
          style: TextStyle(fontSize: screenwidth*0.06,
              fontFamily: "NotoSans",
              color: Color.fromARGB(233, 94, 208, 184),
              fontWeight: FontWeight.bold),
          textScaleFactor: 1.0,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(15, 20, 10, 5),
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("이용자 유형 선택 ",
                        style: TextStyle(fontSize: screenwidth*0.06,
                            fontFamily: "NotoSans",
                            color: Color.fromARGB(255, 108, 108, 108),
                            fontWeight: FontWeight.bold
                        )
                    ),
                    Text("",style: TextStyle(fontSize:  screenwidth*0.015),),
                    Text("이용자 맞춤형 경로를 제공해드립니다.",
                        style: TextStyle(fontSize: screenwidth*0.04,
                          fontFamily: "NotoSans",
                          color: Colors.black,
                        )
                    ),
                  ],
                ),
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                      Get.to(MainPage(
                        selectedcase: "0",
                      ));
                    },
                    child: Container(
                      height: screenwidth*0.4,
                      width: screenwidth*0.4,
                      margin: EdgeInsets.fromLTRB(20, 10, 10, 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(screenwidth*0.08),

                      ),
                      child: Container(
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Column(
                            children: [
                              IconButton(
                                icon: Image.asset("assets/image/eldery.png"),
                                iconSize: screenwidth*0.2,
                                onPressed: (){
                                  Get.to(MainPage(
                                    selectedcase: "0",
                                  ));
                                },
                              ),
                              Text("",style: TextStyle(fontSize:  screenwidth*0.01),),
                              Text("고령자",
                                style: TextStyle(fontSize: screenwidth*0.05,fontFamily: "NotoSans", fontWeight: FontWeight.bold),
                                textScaleFactor: 1.0,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ]
                        ),
                      )
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Get.to(MainPage(
                        selectedcase: "1",
                      ));
                    },
                    child: Container(
                        height: screenwidth*0.4,
                        width: screenwidth*0.4,
                        margin: EdgeInsets.fromLTRB(10, 10, 20, 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(screenwidth*0.08),

                        ),
                        child: Container(
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Column(
                              children: [
                                IconButton(
                                  icon: Image.asset("assets/image/hurt.png"),
                                  iconSize: screenwidth*0.2,
                                  onPressed: (){
                                    Get.to(MainPage(
                                      selectedcase: "1",
                                    ));
                                  },
                                ),
                                Text("",style: TextStyle(fontSize:  screenwidth*0.01),),
                                Text("다리 부상자",
                                  style: TextStyle(fontSize: screenwidth*0.05,fontFamily: "NotoSans", fontWeight: FontWeight.bold),
                                  textScaleFactor: 1.0,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ]
                          ),
                        )
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
                      Get.to(MainPage(
                        selectedcase: "2",
                      ));
                    },
                    child:Container(
                        height: screenwidth*0.4,
                        width: screenwidth*0.4,
                        margin: EdgeInsets.fromLTRB(20, 10, 10, 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(screenwidth*0.08),

                        ),
                        child: Container(
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Column(
                              children: [
                                IconButton(
                                  icon: Image.asset("assets/image/stroller.png"),
                                  iconSize: screenwidth*0.2,
                                  onPressed: (){
                                    Get.to(MainPage(
                                      selectedcase: "2",
                                    ));
                                  },
                                ),
                                Text("",style: TextStyle(fontSize:  screenwidth*0.01),),
                                Text("유아차 이용자",
                                  style: TextStyle(fontSize: screenwidth*0.05,fontFamily: "NotoSans", fontWeight: FontWeight.bold),
                                  textScaleFactor: 1.0,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ]
                          ),
                        )
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Get.to(MainPage(
                        selectedcase: "3",
                      ));
                    },
                  child: Container(
                      height: screenwidth*0.4,
                      width: screenwidth*0.4,
                      margin: EdgeInsets.fromLTRB(10, 10, 20, 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(screenwidth*0.08),

                      ),
                      child: Container(
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Column(
                            children: [
                              IconButton(
                                icon: Image.asset("assets/image/preg.png"),
                                iconSize: screenwidth*0.2,
                                onPressed: (){
                                  Get.to(MainPage(
                                    selectedcase: "3",
                                  ));
                                },
                              ),
                              Text("",style: TextStyle(fontSize:  screenwidth*0.01),),
                              Text("임산부",
                                style: TextStyle(fontSize: screenwidth*0.05,fontFamily: "NotoSans", fontWeight: FontWeight.bold),
                                textScaleFactor: 1.0,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ]
                        ),
                      )
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
                      Get.to(MainPage(
                        selectedcase: "4",
                      ));
                    },
                    child: Container(
                        height: screenwidth*0.4,
                        width: screenwidth*0.4,
                        margin: EdgeInsets.fromLTRB(20, 10, 10, 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(screenwidth*0.08),

                        ),
                        child: Container(
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Column(
                              children: [
                                IconButton(
                                  icon: Image.asset("assets/image/people.png"),
                                  iconSize: screenwidth*0.2,
                                  onPressed: (){
                                    Get.to(MainPage(
                                      selectedcase: "4",
                                    ));
                                  },
                                ),
                                Text("",style: TextStyle(fontSize:  screenwidth*0.01),),
                                Text("일반 이용자",
                                  style: TextStyle(fontSize: screenwidth*0.05,fontFamily: "NotoSans", fontWeight: FontWeight.bold),
                                  textScaleFactor: 1.0,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ]
                          ),
                        )
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Get.to(MainPage(
                        selectedcase: "5",
                      ));
                    },
                    child: Container(
                        height: screenwidth*0.4,
                        width: screenwidth*0.4,
                        margin: EdgeInsets.fromLTRB(10, 10, 20, 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(screenwidth*0.08),

                        ),
                        child: Container(
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Column(
                              children: [
                                IconButton(
                                  icon: Image.asset("assets/image/wheelchair.png"),
                                  iconSize: screenwidth*0.2,
                                  onPressed: (){
                                    Get.to(MainPage(
                                      selectedcase: "5",
                                    ));
                                  },
                                ),
                                Text("",style: TextStyle(fontSize:  screenwidth*0.01),),
                                Text("휠체어 이용자",
                                  style: TextStyle(fontSize: screenwidth*0.05,fontFamily: "NotoSans", fontWeight: FontWeight.bold),
                                  textScaleFactor: 1.0,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ]
                          ),
                        )
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