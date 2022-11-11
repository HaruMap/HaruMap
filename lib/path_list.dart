import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harumap2/mainpage.dart';
import 'package:harumap2/model/model_path.dart';
import 'package:harumap2/path_info.dart';
import 'package:harumap2/pathdetail.dart';

import 'model/model_addr.dart';
import 'path/deparriv_list.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

List<PathDetail> path = [];
String dep = "";
double dep_lat = 0.0;
double dep_lng = 0.0;
String arrv = "";
double arrv_lat = 0.0;
double arrv_lng= 0.0;

class TabPage extends StatefulWidget{

  List<PathDetail> path;
  String dep;
  double dep_lat;
  double dep_lng;
  String arrv;
  double arrv_lat;
  double arrv_lng;
  TextEditingController dep_controller;
  TextEditingController arrv_controller;
  TabPage({required this.path,
    required this.dep,
    required this.dep_lat,
    required this.dep_lng,
    required this.arrv,
    required this.arrv_lat,
    required this.arrv_lng,
    required this.dep_controller,
    required this.arrv_controller
  });

  @override
  _TabState createState() => _TabState();

}

TextEditingController _selectController = TextEditingController(text: "추천순");
class _TabState extends State<TabPage> with TickerProviderStateMixin {
  final Map<int,String> _selectValue = {0:'추천순',1:'최소 시간순',2:'최소 환승순',3:'최소 도보순'};
  // final Map<int,String> _valueList =  {1:'추천순',2:'최소 시간순',3:'최소 환승순',4:'최소 도보순'};
  final String _selectedValue = '추천순';

  late TabController _tabController;
  @override
  void initState(){
    _tabController = TabController(
      length: 4,
      vsync: this,
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    path = widget.path;
    dep = widget.dep;
    dep_lat = widget.dep_lat;
    dep_lng = widget.dep_lng;
    arrv = widget.arrv;
    arrv_lat = widget.arrv_lat;
    arrv_lng = widget.arrv_lng;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 245, 245),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text("하루 지도",
          style: TextStyle(fontSize: width*0.06,
              fontFamily: "NotoSans",
              color: Color.fromARGB(233, 94, 208, 184),
              fontWeight: FontWeight.bold),
          textScaleFactor: 1.0,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Default(widget.dep_controller,widget.arrv_controller,height,width),
          Container(
            height: height*0.08,
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(10, 5.0, 10, 5.0),
                  height: height,
                  width: width*0.6,
                  child: TabBar(
                      indicatorWeight: 1,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: Colors.white,
                      unselectedLabelColor: Color(0xFFDDDDDD),
                      labelColor: Colors.black,
                      unselectedLabelStyle: TextStyle(color: Colors.black, fontSize: width*0.04),
                      labelStyle: TextStyle(
                          color: Colors.black, fontSize: width*0.05, fontWeight: FontWeight.bold),
                      isScrollable: true,
                      controller: _tabController,
                      tabs: [
                        Tab(
                          child: Text("전체",
                            style: TextStyle(
                                fontFamily: "NotoSans"),
                            textScaleFactor: 1.0,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Tab(
                          child: Text("버스",
                            style: TextStyle(
                                fontFamily: "NotoSans"),
                            textScaleFactor: 1.0,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Tab(
                          child: Text("지하철",
                            style: TextStyle(
                                fontFamily: "NotoSans"),
                            textScaleFactor: 1.0,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Tab(
                          child: Text("버스+지하철",
                            style: TextStyle(
                                fontFamily: "NotoSans"),
                            textScaleFactor: 1.0,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ]
                  ),
                ),

                Container(
                  margin: EdgeInsets.fromLTRB(10, 10.0, 10, 0.0),
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(233, 94, 208, 184),
                    borderRadius: BorderRadius.circular(width*0.03),

                  ),
                  height: height*0.05,
                  // width: width*0.3,
                  child: TextButton(
                    // style: TextButton.styleFrom(backgroundColor: Color.fromARGB(233, 94, 208, 184), shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.all(Radius.circular(height*0.01))
                    // ), ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("${_selectController.text}",
                          style: TextStyle(
                              fontFamily: "NotoSans", fontSize: width*0.035,color: Colors.white, fontWeight: FontWeight.bold),
                          textScaleFactor: 1.0,
                          overflow: TextOverflow.ellipsis,),
                        Icon(Icons.keyboard_arrow_down,size:  width*0.05,color: Colors.white,)
                      ],
                    ),
                    onPressed: (){
                      showDialog(context: context,
                          builder: (BuildContext ctx) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(height*0.05))
                          ),
                          content: SizedBox(
                              height: height*0.08,
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(10, 5, 0, 3),
                                    alignment: Alignment.topLeft,
                                    child: Text("정렬 기준",
                                      style: TextStyle(
                                          fontFamily: "NotoSans",
                                          fontWeight: FontWeight.bold,
                                          fontSize: width*0.065),
                                      textScaleFactor: 1.0,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    height: 1,
                                    width: width*0.7,
                                    decoration: BoxDecoration(
                                      color: Colors.black
                                    ),
                                  ),
                                ],
                              ),

                          ),
                         actionsAlignment: MainAxisAlignment.start,
                          actions: [
                            Container(
                              height: height*0.4,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: ListView.separated(
                                        padding: EdgeInsets.all(8),
                                        itemCount: 4,
                                        itemBuilder: (context,int index){
                                          return _buildList(index,height,width);
                                        },
                                        separatorBuilder: (context, int index){
                                          return Divider();
                                        },
                                      ),
                                    ),
                                  ],

                                ),

                            )
                         ],
                        );
                      });
                    }
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: Container(
                  height: height*0.1,
                margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: PathListPage()
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: PathListPage()
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: PathListPage()
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: PathListPage()
                    )
                  ],
                )
              )
          )
        ],
      ),
    );
  }
  final List<String> _selectValueText = ["이동 불편 지수가 적은 최적의 경로를 추천합니다.",
  "시간이 적게 걸리는 순서로 경로를 추천합니다.",
  "환승을 적게 하는 순서로 경로를 추천합니다.",
  "적게 걷는 순서로 경로를 추천합니다."];
  Widget _buildList(int index, double height, double width) {
    print(index);
    return Container(
      height: height*0.15,
        child: TextButton(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("${_selectValue[index]}",
                style: TextStyle(
                    fontFamily: "NotoSans",
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: width*0.05),
                textScaleFactor: 1.0,
                overflow: TextOverflow.ellipsis,
              ),
              Text(""),
              Flexible(child: RichText(
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                strutStyle: StrutStyle(fontSize:width*0.03 ),
                text: TextSpan(
                  text: _selectValueText[index],
                  style: TextStyle(
                      fontFamily: "NotoSans",
                      color: Colors.black,
                      fontSize: width*0.03),
                ),
              ))
            ],
          ),
          onPressed: (){
            _selectController.text = _selectValue[index]!;
            Navigator.push(context,
                MaterialPageRoute(
                    builder: (context) => TabPage(
                        path: path,
                        dep: dep,
                        dep_lat: dep_lat,
                        dep_lng: dep_lng,
                        arrv: arrv,
                        arrv_lat: arrv_lat,
                        arrv_lng: arrv_lng,
                      dep_controller: widget.dep_controller,
                      arrv_controller: widget.arrv_controller,
                    )
                )
            );

          },
        ),
    );

  }
  Widget Default(TextEditingController depcontroller, TextEditingController arrvcontroller, height, width) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 15.0),
          child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
                  child:
                  TextField(
                      controller: depcontroller,
                      decoration: InputDecoration(
                        labelText: depcontroller.text,
                        prefixText: "출발지 : ",
                        fillColor: Colors.white,
                        filled: true,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide.none
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide.none
                        ),
                      )
                  ),
                  padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 5.0),
                ),
                Container(
                    child: TextField(
                      controller: arrvcontroller,
                      decoration: InputDecoration(
                        labelText: arrvcontroller.text,
                        prefixText: "도착지 : ",
                        fillColor: Colors.white,
                        filled: true,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide.none
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide.none
                        ),
                      ),
                    ),
                    padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 5.0)
                ),

              ]
          ),
        ),
      ],
    );
  }
}

class PathListPage extends StatefulWidget {
   @override
  _PathListPageState createState() => _PathListPageState();

}

String startText = "";
String stopText = "";
bool Flag = false;
String newstartText = "";
String newstopText = "";


class _PathListPageState extends State<PathListPage>{

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return WillPopScope(
        child:Scaffold(
          body: SingleChildScrollView(
            child: Container(
              height: height,
              width: width,
              child: Column(
                children: <Widget>[
                  Container(
                    height: height,
                    width: width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ListView.separated(
                            padding: EdgeInsets.all(8),
                            itemCount: path.length,
                            itemBuilder: (context,int index){
                              return _makepath(path[index]);
                            },
                            separatorBuilder: (context, int index){
                              return Divider();
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        onWillPop: (){
          Flag = false;
          Get.off(MainPage());
          return Future(() => true);
        }
    );
  }

  Widget _makepath(PathDetail _pathes) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    Map icons = {'지하철': Icons.directions_subway,
                  "버스": Icons.directions_bus,
                  "도보": Icons.directions_walk,};
    List sub_color = [Colors.blueAccent,Colors.green, Colors.orange, Colors.lightBlue, Colors.deepPurple, Colors.brown];
    List<Widget> containers = [];
    for(int i=0; i<_pathes.totaldescription.length; i++){
      List<String> totaldesc = _pathes.totaldescription[i].split(":");
      var kind = totaldesc[0].split(" ")[0];
      var time = int.parse(totaldesc[1].split(" ")[1]);
      var color = Colors.white10;
      if (kind == "지하철"){
        color = sub_color[int.parse(totaldesc[1].split(" ")[2])-1];
      }
      if (kind == "버스"){
        color = Colors.indigo;
      }
      if (kind == "도보"){
        color = Colors.grey;
      }

      containers.add(
        Container(
          child: Icon(
            icons[kind],
            color: color,
            size: 25,
          ),
          margin: EdgeInsets.fromLTRB(10, 5, 0, 10),
        ),
      );
      containers.add(
        Container(
          child: Text("${time}분",
            style:TextStyle(fontSize: 10,
                fontFamily: "NotoSans",
                color: Colors.black,) ,),
          margin: EdgeInsets.fromLTRB(2, 5, 3, 10),
        )
      );
    }
    return Container(
        // padding: EdgeInsets.fromLTRB(10, 2, 10, 10),
        margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
        width: width*0.9,
        height: height*0.17,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(width*0.1),

        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) => PathInfoPage(
                        path: _pathes,
                        dep: dep,
                        dep_lat: dep_lat,
                        dep_lng: dep_lng,
                        arrv: arrv,
                        arrv_lat: arrv_lat,
                        arrv_lng: arrv_lng,
                      )
                    )
                  );
                                     },
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
                        child: Text("${_pathes.totaltime}분 ",
                          style:TextStyle(fontSize: 30,
                            fontFamily: "NotoSans",
                            color: Colors.black,
                          fontWeight: FontWeight.bold) ,),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: containers
                      )
                    ],
                  ),
                ),

              ),
            ]
        )
    );
  }

}



