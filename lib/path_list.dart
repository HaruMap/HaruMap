import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../mainpage.dart';
import '../model/model_path.dart';
import '../path_info.dart';
import 'package:kakaomap_webview/kakaomap_webview.dart';

import 'model/getpath_api_adapter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'selectcase.dart';

List<WayDetail> path = [];
String dep = "";
double dep_lat = 0.0;
double dep_lng = 0.0;
String arrv = "";
double arrv_lat = 0.0;
double arrv_lng= 0.0;
String selectedcase = "";
String orders = "";

class TabPage extends StatefulWidget{

  List<WayDetail> path;
  String dep;
  double dep_lat;
  double dep_lng;
  String arrv;
  double arrv_lat;
  double arrv_lng;
  TextEditingController dep_controller;
  TextEditingController arrv_controller;
  String selectedcase;
  String orders;
  TabPage({
    required this.selectedcase,
    required this.path,
    required this.dep,
    required this.dep_lat,
    required this.dep_lng,
    required this.arrv,
    required this.arrv_lat,
    required this.arrv_lng,
    required this.dep_controller,
    required this.arrv_controller,
    required this.orders
  });

  @override
  _TabState createState() => _TabState();

}

var fontsizescale = 1.0;
TextEditingController _selectController = TextEditingController(text: "추천순");
class _TabState extends State<TabPage> with TickerProviderStateMixin {
  final Map<int,String> _selectValue = {0:'추천순',1:'최소 시간순',2:'최소 도보순'};

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
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    fontsizescale = 1.0;
    if(widget.selectedcase == "0"){
      fontsizescale = 1.2;
    }
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    selectedcase = widget.selectedcase;
    path = widget.path;
    dep = widget.dep;
    dep_lat = widget.dep_lat;
    dep_lng = widget.dep_lng;
    arrv = widget.arrv;
    arrv_lat = widget.arrv_lat;
    arrv_lng = widget.arrv_lng;
    orders = widget.orders;
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 245, 245, 245),
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
            title: Text("하루지도",
              style: TextStyle(fontSize: width*0.06,
                  fontFamily: "NotoSans",
                  color: Color.fromARGB(233, 94, 208, 184),
                  fontWeight: FontWeight.bold),
              textScaleFactor: 1.0,
              overflow: TextOverflow.ellipsis,
            ),
            centerTitle: true,
            leading:  IconButton(
                onPressed: () {
                  Flag = false;
                  Get.off(MainPage(
                    selectedcase: selectedcase,
                  ));
                },
                color: Color.fromARGB(233, 94, 208, 184),
                icon: Icon(Icons.arrow_back_ios)
            ),
            actions: <Widget>[
              Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: IconButton(
                      onPressed: (){
                        dep_ok = false;
                        arrv_ok = false;
                        startok = false;
                        stopok = false;
                        depController.text= " ";
                        arrvController.text= " ";
                        Get.offAll(SelectCasePage());
                      },
                      icon: Icon(
                        Icons.home_outlined,
                        color: Color.fromARGB(233, 94, 208, 184),
                      )
                  )
              ),
            ],
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
                          unselectedLabelStyle: TextStyle(color: Colors.black, fontSize: width*0.04*fontsizescale),
                          labelStyle: TextStyle(
                              color: Colors.black, fontSize: width*0.05*fontsizescale , fontWeight: FontWeight.bold),
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
                              child: Text("지하철",
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
                      height: height*0.05*fontsizescale,
                      child: TextButton(
                        // style: TextButton.styleFrom(backgroundColor: Color.fromARGB(233, 94, 208, 184), shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.all(Radius.circular(height*0.01))
                        // ), ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("${_selectController.text}",
                                style: TextStyle(
                                    fontFamily: "NotoSans", fontSize: width*0.035*fontsizescale ,color: Colors.white, fontWeight: FontWeight.bold),
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
                                                  fontSize: width*0.065*fontsizescale ),
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
                                        height: height*0.4*fontsizescale,
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: ListView.separated(
                                                padding: EdgeInsets.all(8),
                                                itemCount: 3,
                                                itemBuilder: (context,int index){
                                                  return _buildList(index,height,width,orders);
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
                              child: PathListPage(way: 0,)
                          ),
                          Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: PathListPage(way: 1,)
                          ),
                          Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: PathListPage(way: 2,)
                          ),
                          Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: PathListPage(way: 3,)
                          )
                        ],
                      )
                  )
              )
            ],
          ),
        ),
        onWillPop: (){
          dep_ok = false;
          arrv_ok = false;
          startok = false;
          stopok = false;
          depController.text= " ";
          arrvController.text= " ";
          Get.offAll(MainPage(selectedcase: selectedcase));
          return Future(() => true);
        }
    );
  }
  List<WayDetail> newpathes = [];
  _loadPath(deplat,deplng,arrvlat,arrvlng,order) async {
    String baseUrl = "/haruapp/getPathes?user=${widget.selectedcase}&orders=${order}&deplat=${deplat}&deplng=${deplng}&arrvlat=${arrvlat}&arrvlng=${arrvlng}";
    print(baseUrl);
    final response = await http.get(
      Uri.parse(baseUrl),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      setState(() {
        newpathes = parsewayPathes(convert.utf8.decode(response.bodyBytes));
      });
    }else{
      throw Exception("failed to load data");
    }
  }
  final List<String> _selectValueText = ["이동 불편 지수가 적은 최적의 경로를 추천합니다.",
  "시간이 적게 걸리는 순서로 경로를 추천합니다.",
  "적게 걷는 순서로 경로를 추천합니다."];
  Widget _buildList(int index, double height, double width, String order) {
    return Container(
      height: height*0.15*fontsizescale,
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
                    fontSize: width*0.05*fontsizescale ),
                textScaleFactor: 1.0,
                overflow: TextOverflow.ellipsis,
              ),
              Text(""),
              Flexible(child: RichText(
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                strutStyle: StrutStyle(fontSize:width*0.03*fontsizescale ),
                text: TextSpan(
                  text: _selectValueText[index],
                  style: TextStyle(
                      fontFamily: "NotoSans",
                      color: Colors.black,
                      fontSize: width*0.03*fontsizescale ),
                ),
              ))
            ],
          ),
          onPressed: (){
            _selectController.text = _selectValue[index]!;
            order = "${index}";
            print("order: "+order);
            _loadPath(dep_lat,dep_lng,arrv_lat,arrv_lng,index).whenComplete((){
              return Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) => TabPage(
                        selectedcase: widget.selectedcase,
                        path: newpathes,
                        dep: dep,
                        dep_lat: dep_lat,
                        dep_lng: dep_lng,
                        arrv: arrv,
                        arrv_lat: arrv_lat,
                        arrv_lng: arrv_lng,
                        dep_controller: widget.dep_controller,
                        arrv_controller: widget.arrv_controller,
                        orders: order,
                      )
                  )
              );
            });


          },
        ),
    );

  }
  Widget Default(TextEditingController depcontroller, TextEditingController arrvcontroller, height, width) {
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
                        prefixText: "출발지 ",
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
                        prefixText: "도착지 ",
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

  int way;

  PathListPage({required this.way});
   @override
  _PathListPageState createState() => _PathListPageState();

}

String startText = "";
String stopText = "";
bool Flag = false;
String newstartText = "";
String newstopText = "";

List<PathDetail> waypathes = [];
class _PathListPageState extends State<PathListPage>{
  @override
  Widget build(BuildContext context) {
    print(path);
    if(path.length > 0){
      if (widget.way == 0){
        waypathes = parsePathes(path[0].tot);
      }if (widget.way == 1){
        waypathes = parsePathes(path[0].sub);
      }if (widget.way == 2){
        waypathes = parsePathes(path[0].bus);
      }if (widget.way == 3){
        waypathes = parsePathes(path[0].subbus);
      }
      var height = MediaQuery.of(context).size.height;
      var width = MediaQuery.of(context).size.width;
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
                              itemCount: waypathes.length,
                              itemBuilder: (context,int index){
                                return _makepath(waypathes[index], index);
                              },
                              separatorBuilder: (context, int index){
                                return Divider();
                              },
                            ),
                          ),
                          Container(
                            height: height*0.25,
                            width: width,
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
            Get.off(MainPage(
              selectedcase: selectedcase,
            ));
            return Future(() => true);
          }
      );
    }else{
      var height = MediaQuery.of(context).size.height;
      var width = MediaQuery.of(context).size.width;
      return WillPopScope(
          child:Scaffold(
            body: SingleChildScrollView(
              child: Container(
                height: height*0.4,
                width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(width*0.1),
                  ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("경로가 없어요ㅠㅠ",
                      style: TextStyle(
                          fontFamily: "NotoSans",
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: width*0.05*fontsizescale ),),
                    IconButton(
                      icon: Image.asset("assets/image/sad.png"),
                      iconSize: width*0.2,
                      onPressed: (){
                        Get.off(MainPage(
                          selectedcase: selectedcase,
                        ));
                      },
                    ),
                  ],
                )
              ),
            ),
          ),
          onWillPop: (){
            Flag = false;
            Get.off(MainPage(
              selectedcase: selectedcase,
            ));
            return Future(() => true);
          }
      );
    }

  }

  Widget _makepath(PathDetail _pathes, int index) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    Map icons = {'지하철': Icons.directions_subway,
                  "버스": Icons.directions_bus,
                  "도보": Icons.directions_walk,};
    List sub_color = [Color(0xff0052a4),Color(0xff00a84d),Color(0xffef7c1c),Color(0xff00a5de),Color(0xff996cac),Color(0xffcd7c2f),
      Color(0xff747f00),Color(0xffe6186c),Color(0xffbdb092)];
    List<Widget> containers = [];

    List corcolors = [];
    for(int i=0; i<_pathes.totaldescription.length; i++){
      List<dynamic> totaldesc = _pathes.totaldescription[i];
      print(totaldesc);
      var kind = totaldesc[0];
      var time = totaldesc[1];
      var color = Colors.white10;
      if (kind == "지하철"){
        color = sub_color[totaldesc[2]-1];
        corcolors.add(color.toHex);
      }
      if (kind == "버스"){
        color = Color(0xff0068b7);
        corcolors.add(color.toHex);
      }
      if (kind == "도보"){
        color = Colors.grey;
        corcolors.add(color.toHex);
      }
      containers.add(
        Container(
          child: Icon(
            icons[kind],
            color: color,
            size: 25*fontsizescale,
          ),
          margin: EdgeInsets.fromLTRB(10, 0, 2, 10),
        ),
      );
      containers.add(
        Container(
          child: Text("${time}분",
            style:TextStyle(fontSize: 15*fontsizescale ,
                fontFamily: "NotoSans",
                color: Colors.black,) ,),
          margin: EdgeInsets.fromLTRB(2, 10*fontsizescale, 3, 10),
        )
      );
    }
    return Container(
        // padding: EdgeInsets.fromLTRB(10, 2, 10, 10),
        margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
        width: width*0.9,
        height: height*0.18*fontsizescale,
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
                        corcolor: corcolors,
                        selectedcase: selectedcase,
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
                        child: Text("${_pathes.totaltime.toInt()}분 ",
                          style:TextStyle(fontSize: 30*fontsizescale ,
                            fontFamily: "NotoSans",
                            color: Colors.black,
                          fontWeight: FontWeight.bold) ,),
                      ),
                      Container(
                        height: height*0.1*fontsizescale,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ListView.separated(
                                  padding: EdgeInsets.all(10),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: containers.length,
                                  itemBuilder: (context,int index){
                                    return containers[index];
                                  },
                                  separatorBuilder: (context, int index){
                                    return const Divider();
                                  },
                                ),
                              ),
                            ]
                        ),
                      ),

                    ],
                  ),
                ),

              ),
            ]
        )
    );
  }

}



