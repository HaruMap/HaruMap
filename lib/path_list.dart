import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harumap2/mainpage.dart';
import 'package:harumap2/model/model_path.dart';
import 'package:harumap2/path_info.dart';

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
  TabPage({required this.path, required this.dep, required this.dep_lat, required this.dep_lng, required this.arrv, required this.arrv_lat, required this.arrv_lng});

  @override
  _TabState createState() => _TabState();

}

class _TabState extends State<TabPage> with TickerProviderStateMixin {

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
          style: TextStyle(fontSize: screenwidth*0.06,
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
      var width = (context.width*(time/2))/(_pathes.totaldescription.length*100);
      if (width > 30){
        width = 25.0;
      }
      if(width <3){
        width = 3.0;
      }
      print(width);
      containers.add(
        Container(
          height: 3.0,
          width: width,
          color: color,
          margin: EdgeInsets.fromLTRB(2, 10, 0, 10),
        ),
      );
      containers.add(
        Icon(
          icons[kind],
          color: color,
          size: 30,
        ),
      );
      containers.add(
        Container(
          height: 3.0,
          width: width,
          color: color,
          margin: EdgeInsets.fromLTRB(2, 10, 0, 10),
        ),
      );
    }
    return Container(
        padding: EdgeInsets.fromLTRB(10, 2, 10, 10),
        margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) => PathInfoPage(
                        path: path,
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
                child: Column(
                  children:[
                    Container(
                      child: Text("${dep}에서 ${arrv}까지 ${_pathes.totaltime}분 ",
                        style:TextStyle(fontSize: 18) ,),
                      margin: EdgeInsets.fromLTRB(5, 0, 5, 10),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: containers
                      ,
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
                labelText: "${dep}",
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
                  labelText: " ${arrv}",
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

