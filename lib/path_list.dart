import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harumap2/mainpage.dart';
import 'package:harumap2/path_info.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'model/getaddr_api_adapter.dart';
import 'model/model_addr.dart';

class TabPage extends StatefulWidget{

  @override
  _TabState createState() => _TabState();

}

class _TabState extends State<TabPage> with TickerProviderStateMixin {

  bool isLoading = false;
  List<AddrLoc> locs = [];

  String addr= "";

  _loadLoc() async {
    setState(() {
      isLoading = true;
    });
    String baseUrl = "http://127.0.0.1:8000/?addr=$addr";
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      setState(() {
        locs = parseAddrLoc(convert.utf8.decode(response.bodyBytes));
        isLoading = false;
      });
    }else{
      throw Exception("failed to load data");
    }
  }

  late TabController _tabController;
  @override
  void initState(){
    _tabController = TabController(
      length: 3,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (Flag){
      pathes = [
        Pathes(10, newstartText, newstopText, pathdetail),
        Pathes(10, newstartText, newstopText, pathdetail),
        Pathes(10, newstartText, newstopText, pathdetail),
        Pathes(10, newstartText, newstopText, pathdetail),
      ];
    }else{
      startText = Get.find<Controller>().startText;
      stopText = Get.find<Controller>().stopText;
      pathes = [
        Pathes(10, startText, stopText, pathdetail),
        Pathes(10, startText, stopText, pathdetail),
        Pathes(10, startText, stopText, pathdetail),
        Pathes(10, startText, stopText, pathdetail),
      ];
    }
    return Scaffold(
      body: Column(
        children: [
          Default(),
          Container(
            height: 40,
            child: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: Colors.blue,
                unselectedLabelColor: Colors.black,
                labelColor: Colors.yellow,
                unselectedLabelStyle: TextStyle(color: Colors.black),
                controller: _tabController,
                tabs: [
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Text("버스"),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    // height: 20,
                    child: Text("지하철"),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    // height: 20,
                    child: Text("버스+지하철"),
                  ),
                ]
            ),
          ),
          Expanded(
              child: Container(
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
                    )
                  ],
                )
              )
          )
        ],
      ),
    );
  }
}

class PathListPage extends StatefulWidget {

  @override
  _PathListPageState createState() => _PathListPageState();

}

class Pathes{
  int time;
  String start;
  String stop;
  List<String> pathes;

  Pathes(this.time,this.start,this.stop,this.pathes);
}

String startText = "";
String stopText = "";
bool Flag = false;
String newstartText = "";
String newstopText = "";
List<String> pathdetail = <String>['a','b','c'];
List pathes = [];

class _PathListPageState extends State<PathListPage>{

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return WillPopScope(
        child:Scaffold(
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ListView.separated(
                            padding: EdgeInsets.all(8),
                            itemCount: pathes.length,
                            itemBuilder: (context,int index){
                              return PathList(pathes[index]);
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
}


class PathList extends StatelessWidget{
  PathList(this._pathes);
  final Pathes _pathes;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return Container(
        padding: EdgeInsets.fromLTRB(10, 2, 10, 10),
        margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: (){
                Get.to(PathInfoPage());
              },
              child: Column(
                  children:[
                    Container(
                      child: Text("20분 ${_pathes.start} ~ ${_pathes.stop}",
                        style:TextStyle(fontSize: 18) ,),
                      margin: EdgeInsets.fromLTRB(5, 0, 5, 10),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 2.0,
                          width: 10.0,
                          color: Colors.deepPurple,
                          margin: EdgeInsets.fromLTRB(2, 10, 0, 10),
                        ),
                        Icon(
                          Icons.directions_subway,
                          color: Colors.deepPurple,
                          size: 35,
                        ),
                        Container(
                          height: 2.0,
                          width: 10.0,
                          color: Colors.deepPurple,
                          margin: EdgeInsets.fromLTRB(0, 10, 2, 10),
                        ),
                        Container(
                          height: 1.0,
                          width: 10.0,
                          color: Colors.grey,
                          margin: EdgeInsets.fromLTRB(2, 10, 0, 10),
                        ),
                        Icon(
                          Icons.directions_walk,
                          color: Colors.grey,
                          size: 35,
                        ),
                        Container(
                          height: 1.0,
                          width: 10.0,
                          color: Colors.grey,
                          margin: EdgeInsets.fromLTRB(0, 10, 2, 10),
                        ),
                        Container(
                          height: 2.0,
                          width: 10.0,
                          color: Colors.indigo,
                          margin: EdgeInsets.fromLTRB(2, 10, 0, 10),
                        ),
                        Icon(
                          Icons.directions_bus,
                          color: Colors.indigo,
                          size: 35,
                        ),
                        Container(
                          height: 2.0,
                          width: 10.0,
                          color: Colors.indigo,
                          margin: EdgeInsets.fromLTRB(0, 10, 2, 10),
                        ),
                      ],
                    )
                  ],
              ),
              ),
          ]
        )
    );
  }
}

class Default extends StatefulWidget{
  @override
  _DefaultState createState() => _DefaultState();
}

class _DefaultState extends State<Default> {

  void _anotherpath(){
    setState(() {
      if (newstartText.isEmpty || newstopText.isEmpty) {
        showDialog(context: context,
            builder: (BuildContext buildcontext) {
              return AlertDialog(
                content: Text("값을 입력해주세요"),
                actions: [
                  Center(
                    child: TextButton(
                      child: Text('확인'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                ],
              );
            });
      }
      else {
        Flag = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    var screenwidth = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          child: TextField(
            textInputAction: TextInputAction.next,
            onChanged: (text) {
              newstartText = text;
            },
            decoration: InputDecoration(
                labelText: " $startText",
                labelStyle: TextStyle(
                    fontSize: screenwidth*0.045,
                    fontFamily: "NanumSquare"
                ),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                )
            ),
          ),
          padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 5.0),
        ),
        Padding(
            child: TextField(
              textInputAction: TextInputAction.go,
              onSubmitted: (text) {
                newstopText = text;
                _anotherpath();
              },
              decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelText: " $stopText",
                  labelStyle: TextStyle(
                      fontSize: screenwidth*0.045,
                      fontFamily: "NanumSquare"
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                  )
              ),
            ),
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 5.0)
        ),
      ],
      // ),
    );
  }
}

