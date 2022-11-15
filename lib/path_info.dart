
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:harumap2/pathdetail.dart';
import 'package:kakaomap_webview/kakaomap_webview.dart';

import 'model/model_path.dart';



class PathInfoPage extends StatefulWidget{

  PathDetail path;
  String dep;
  double dep_lat;
  double dep_lng;
  String arrv;
  double arrv_lat;
  double arrv_lng;
  List<dynamic> corcolor;
  PathInfoPage({required this.path, required this.dep, required this.dep_lat, required this.dep_lng, required this.arrv, required this.arrv_lat, required this.arrv_lng, required this.corcolor});

  @override
  _PathInfoState createState() => _PathInfoState();
}

var path;
String dep = "";
double dep_lat = 0.0;
double dep_lng = 0.0;
String arrv = "";
double arrv_lat = 0.0;
double arrv_lng= 0.0;
bool _expanded = true;
List<List> kakaocor = [];

class _PathInfoState extends State<PathInfoPage>{

  @override
  Widget build(BuildContext context) {
    path = widget.path;
    dep = widget.dep;
    dep_lat = widget.dep_lat;
    dep_lng = widget.dep_lng;
    arrv = widget.arrv;
    arrv_lat = widget.arrv_lat;
    arrv_lng = widget.arrv_lng;
    screenheight = MediaQuery.of(context).size.height;
    screenwidth = MediaQuery.of(context).size.width;
    print(widget.corcolor);

    for (int i=0; i<widget.corcolor.length; i++){
      var cor = path.coordinate[i];
      var tmpcor = [];
      for (int j=0; j<cor.length; j++){
        tmpcor.add([cor[j][2],cor[j][1]]);
      }
      kakaocor.add(tmpcor);
    }
    print(kakaocor[0][0]);
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
      body: Stack(
        children: [
          _showmap(context),
        detaildescription(pathes: path) ,

        ],
      )
    );
  }

  String kakaoMapKey = "";
  Future<String> _loadKeyAsset() async {
    return await rootBundle.loadString('assets/json/kakaojskey.json');
  }
  @override
  Widget _showmap(BuildContext context) {
    return FutureBuilder<String>(
        future: _loadKeyAsset(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot){
          if (snapshot.hasData){
            kakaoMapKey = snapshot.data!.split(":")[1].split("}")[0].split("\"")[1] as String;
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                  child: KakaoMapView(
                    width: screenwidth ,
                    height: screenheight * 0.6,
                    kakaoMapKey: kakaoMapKey,
                    lat: dep_lat,
                    lng: dep_lng,
                    showMapTypeControl: true,
                    showZoomControl: true,
                    draggableMarker: true,
                    customScript: '''
                  var markers = [];   
                  var complete_dep = true;
                  var complete_arrv = true;
                  var i = 0;
                  var bounds = new kakao.maps.LatLngBounds();
                  
                  function addMarker(position) {              
                    var marker = new kakao.maps.Marker({position: position});              
                    marker.setMap(map);              
                    markers.push(marker);
                  }
                  var marker1 = new kakao.maps.LatLng(${dep_lat},${dep_lng});
                  
                  var marker2 = new kakao.maps.LatLng($arrv_lat,$arrv_lng)
                   
                  addMarker(marker1);
                  bounds.extend(marker1);
                                      
                  addMarker(marker2);
                  bounds.extend(marker2);
                  const dep_content = '<div class="customoverlay" style="padding:5px;">' + '    <span style ="display:block;text-align:center;background:#fff;margin-right:35px;padding:10px 15px;font-size:14px;font-weight:bold;border-radius:6px;border: 1px solid #ccc;border-bottom:2px solid #ddd; box-shadow:0px 1px 2px #888;" >$dep</span>' + '</div>';
                    var dep_customOverlay = new kakao.maps.CustomOverlay({
                            map: map,
                            position: marker1,
                            content: dep_content,
                            yAnchor: 2
                       
                        });
                  
                  const arrv_content = '<div class="customoverlay" style="padding:5px;">' + '    <span style ="display:block;text-align:center;background:#fff;margin-right:35px;padding:10px 15px;font-size:14px;font-weight:bold;border-radius:6px;border: 1px solid #ccc;border-bottom:2px solid #ddd; box-shadow:0px 1px 2px #888;" >$arrv</span>' + '</div>';
                  var dep_customOverlay = new kakao.maps.CustomOverlay({
                            map: map,
                            position: marker2,
                            content: arrv_content,
                            yAnchor: 2
                       
                        });
                        
                  setBounds()
            
                  var zoomControl = new kakao.maps.ZoomControl();
                  map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);              
                  var mapTypeControl = new kakao.maps.MapTypeControl();
                  map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
                  
                  function panTo(lat,lng) {
                      var moveLatLon = new kakao.maps.LatLng(lat,lng);
                      
                      map.panTo(moveLatLon);            
                  }   
                  function setBounds() {
                      map.setBounds(bounds);
                  }             
                  
                  for (var i=0; i<${widget.corcolor.length};i++){
                    var cor = ${kakaocor}
                    var color = ${widget.corcolor}
                    var linePath = [];
                    for (var j=0; j<cor[i].length; j++){
                      linePath.push(new kakao.maps.LatLng(cor[i][j][0],cor[i][j][1]));
                    }
                    var polyline = new kakao.maps.Polyline({
                          path: linePath, // 선을 구성하는 좌표배열 입니다
                          strokeWeight: 7, // 선의 두께 입니다
                          strokeColor: color[i], // 선의 색깔입니다
                          strokeOpacity: 1, // 선의 불투명도 입니다 1에서 0 사이의 값이며 0에 가까울수록 투명합니다
                          strokeStyle: 'solid' // 선의 스타일입니다
                      }); 
                      polyline.setMap(map);           
                  } 
                  
                  
                  ''',
                  ),
                ),
              ],
            );
          } else{
            return Center(child: CircularProgressIndicator(),);
          }
        }
    );

  }

}

class detaildescription extends StatefulWidget {
  PathDetail pathes;
  detaildescription({required this.pathes});
  @override
  _detaildescription createState() => _detaildescription();

}

class _detaildescription extends State<detaildescription>{

  @override
  Widget build(BuildContext context) {
    PathDetail _pathes = widget.pathes;
    Map icons = {'지하철': Icons.directions_subway,
      "버스": Icons.directions_bus,
      "도보": Icons.directions_walk,};
    List sub_color = [Color(0xff0052a4),Color(0xff00a84d),Color(0xffef7c1c),Color(0xff00a5de),Color(0xff996cac),Color(0xffcd7c2f),
      Color(0xff747f00),Color(0xffe6186c),Color(0xffbdb092)];
    List<double> circle_num = [];
    List<Widget> containers = [];
    List<Widget> leftlines = [];
    List<Widget> rightdesc = [];
    List<Widget> walkdesc = [];
    bool walk = false;

    for(int i=0; i<_pathes.description.length; i++){
      List<dynamic> desc = _pathes.description[i];
      List<Widget> subwaydesc = [];
      List<Widget> busdesc = [];

      var kind = desc[0];
      var color = Colors.white10;

      if (kind == "지하철"){
        List<Widget> subwaystops = [];
        var subway = desc;
        var start = subway[2];
        var stop = subway[3];
        var subwaytime = subway[4];
        // var togo = subway[4];
        var subway_color = subway[1]-1;
        color = sub_color[subway_color];

        // var fastout = desc[1].split("(")[1].split(")")[0].split("/");
        // var out = desc[1].split("(")[2].split(")")[0].split("/");
        var stopby = subway[5];
        var stopbynum = stopby[0];
        for (int i=2; i<stopbynum-1; i++){
          subwaystops.add(
            Row(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(20, 5, 3, 5),
                  child:
                  Icon(
                    Icons.circle_outlined,
                    color: color,
                    size: screenwidth*0.035,
                  ),
                ),
                Container(
                  child: Text("${stopby[i]}",
                    style: TextStyle(fontSize: screenwidth*0.035,
                      fontFamily: "NotoSans",
                      color: Colors.black,),
                  ),
                  margin: EdgeInsets.fromLTRB(30, 5, 3, 5),
                ),
              ],
            ),
          );
        }
        subwaydesc.add(
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      child: Text("${start}",
                        style: TextStyle(fontSize: screenwidth*0.05,
                            fontFamily: "NotoSans",
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      margin: EdgeInsets.fromLTRB(80, 65, 3, 5),
                    ),

                  ],
                ),
                Container(
                  child: Text("${stopbynum}개 역 이동",
                    style: TextStyle(fontSize: screenwidth*0.04,
                      fontFamily: "NotoSans",
                      color: Colors.black,),
                  ),
                  margin: EdgeInsets.fromLTRB(80, 5, 3, 5),
                ),
                // Container(
                //   child: Text("빠른 하차: ${fastout}",
                //     style: TextStyle(fontSize: screenwidth*0.04,
                //       fontFamily: "NotoSans",
                //       color: Colors.black,),
                //   ),
                //   margin: EdgeInsets.fromLTRB(80, 5, 3, 5),
                // ),
                Column(
                  children: subwaystops,
                ),
                Container(
                  child: Text("${stop}",
                    style: TextStyle(fontSize: screenwidth*0.05,
                        fontFamily: "NotoSans",
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  margin: EdgeInsets.fromLTRB(80, 15, 3, 5),
                ),
                // Container(
                //   child: Text("출구: ${out}",
                //     style: TextStyle(fontSize: screenwidth*0.04,
                //       fontFamily: "NotoSans",
                //       color: Colors.black,),
                //   ),
                //   margin: EdgeInsets.fromLTRB(80, 5, 3, 5),
                // ),
              ],
            )
        );
        if(walkdesc.length > 0){
          if (walkdesc.length == 1) {
            circle_num.add(
                0.5
            );
          } else {
            circle_num.add(
                walkdesc.length * 1.0
            );
          }
          rightdesc.add(
              Container(
                child: Column(
                  children: walkdesc,
                ),
              )

          );
          walkdesc = [];
        }

        circle_num.add(
            stopbynum-3.5!
        );
        rightdesc.add(
          Container(
            child:
            Column(
              children: subwaydesc,
            ),
          ),
        );
      }
      if (kind == "버스"){
        List<Widget> busstops = [];
        color = Color(0xff0068b7);
        var bus = desc;
        var start = bus[2];
        var stop = bus[3];
        var bustime = bus[4];
        var bus_stopby_num = bus[5][0];
        var bus_soon_arr = bus[1];
        List<Widget> bus_soons = [];
        for (int i=0; i<bus_soon_arr.length; i++){
          var bus_soon = bus_soon_arr[i];
          var bus_soon_num = bus_soon[0];
          // var bus_soon_time = bus_soon[1];
          // var bus_soon_state = bus_soon[2];
          var bus_soon_margin = 5;
          if (i == 0){
            bus_soon_margin = 101;
          }
          bus_soons.add(
              Row(
                children: [
                  Container(
                    child: Text("${bus_soon_num}",
                      style: TextStyle(fontSize: screenwidth*0.04,
                        fontFamily: "NotoSans",
                        color: Colors.black,),
                    ),
                    margin: EdgeInsets.fromLTRB(bus_soon_margin*1.0, 5, 3, 5),
                  ),
                  // Container(
                  //   child: Text("${bus_soon_state}",
                  //     style: TextStyle(fontSize: screenwidth*0.04,
                  //       fontFamily: "NotoSans",
                  //       color: Colors.black,),
                  //   ),
                  //   margin: EdgeInsets.fromLTRB(2, 5, 3, 5),
                  // )
                ],
              )
          );
        }

        for (int i=1; i<bus_stopby_num-1; i++){
          busstops.add(
            Row(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(20, 5, 3, 5),
                  child:
                  Icon(
                    Icons.circle_outlined,
                    color: color,
                    size: screenwidth*0.035,
                  ),
                ),
                Container(
                  child: Text("${bus[5][i]}",
                    style: TextStyle(fontSize: screenwidth*0.035,
                      fontFamily: "NotoSans",
                      color: Colors.black,),
                  ),
                  margin: EdgeInsets.fromLTRB(30, 5, 3, 5),
                ),
              ],
            ),
          );
        }
        busdesc.add(
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text("${start}",
                    style: TextStyle(fontSize: screenwidth*0.05,
                        fontFamily: "NotoSans",
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  margin: EdgeInsets.fromLTRB(80, 55, 3, 5),
                ),
                Container(
                  child: Text("${bus_stopby_num}개 정류소 이동",
                    style: TextStyle(fontSize: screenwidth*0.04,
                      fontFamily: "NotoSans",
                      color: Colors.black,),
                  ),
                  margin: EdgeInsets.fromLTRB(100, 5, 3, 5),
                ),
                Row(
                  children: bus_soons,
                ),
                Column(
                  children: busstops,
                ),
                Container(
                  child: Text("${stop}",
                    style: TextStyle(fontSize: screenwidth*0.048,
                        fontFamily: "NotoSans",
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  margin: EdgeInsets.fromLTRB(78, 5, 3, 5),
                ),
              ],
            )
        );
        if(walkdesc.length > 0) {
          if (walkdesc.length == 1) {
            circle_num.add(
                0.5
            );
          } else {
            circle_num.add(
                walkdesc.length * 1.0
            );
          }
          rightdesc.add(
              Column(
                children: walkdesc,
              )
          );
          walkdesc = [];
        }

        circle_num.add(
            bus_stopby_num!*1.0
        );
        rightdesc.add(
            Column(
              children: busdesc,
            )
        );

      }
      if (kind == "도보"){
        color = Colors.grey;
        var walk = desc;
        var direction = "";
        var meter = "";
        // var walk_time = "";
        var walk_descrip = "";
        var walkdetail = "";
        if(walk.length == 2){
          direction = "직진";
          meter = walk[1];
          walkdetail = "${meter} ${direction}하세요.";
        }
        if (walk.length == 3){
          direction = walk[1];
          meter = walk[2];
          // var walk_time = walk[3];
          walkdetail = "${direction} 후 ${meter} 이동하세요.";
        }
        if (walk.length == 4){
          direction = walk[1];
          meter = walk[3];
          // var walk_time = walk[2];
          walk_descrip = walk[2];
          walkdetail = "${direction} 후 ${walk_descrip}를 따라 ${meter} 이동하세요.";
        }
        if (direction == "횡단보도"){
          walkdetail = "${direction}를 건너세요.";
        }
        var margin_walk = 6;
        if(walkdesc.length == 0){
          margin_walk = 90;
        }

        walkdesc.add(
            Row(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(20, margin_walk*1.0, 3, 7),
                  child:
                  Icon(
                    Icons.circle_outlined,
                    color: color,
                    size: screenwidth*0.035,
                  ),
                ),
                Container(
                  width: screenwidth*0.6,
                  child: Row(
                    children: [
                      Flexible(child: RichText(
                        maxLines: 3,
                        text: TextSpan(
                          text: walkdetail,
                          style: TextStyle(fontSize: screenwidth*0.04,
                            fontFamily: "NotoSans",
                            color: Colors.black,),

                        ),
                      ),
                      )
                    ],
                  ) ,

                  margin: EdgeInsets.fromLTRB(30, margin_walk*1.0, 0.0, 7),
                ),
              ],
            )
        );

        if(walkdesc.length > 0 && i == _pathes.description.length-1){
          if (walkdesc.length == 1) {
            circle_num.add(
                0.5
            );
          } else {
            circle_num.add(
                walkdesc.length * 1.0
            );
          }
          rightdesc.add(
              Container(
                child: Column(
                  children: walkdesc,
                ),
              )

          );
          walkdesc = [];
        }

      }
    }
    Map<int, Color> corcolors = {1:Colors.white,2:Colors.white,3:Colors.white};
    for(int i=0; i<_pathes.totaldescription.length; i++) {
      List<dynamic> totaldesc = _pathes.totaldescription[i];

      var kind = totaldesc[0];
      var time = totaldesc[1];
      var color = Colors.white10;

      if (kind == "지하철") {
        color = sub_color[totaldesc[2]- 1];
        corcolors[1] = color;
      }
      if (kind == "버스") {
        color = Color(0xff0068b7);
        corcolors[2] = color;
      }
      if (kind == "도보") {
        color = Colors.grey;
        corcolors[3] = color;
      }
      containers.add(
          Expanded(child: Container(
            child: Icon(
              icons[kind],
              color: color,
              size: 25,
            ),
            margin: EdgeInsets.fromLTRB(10, 5, 0, 10),
          ),
          )

      );
      containers.add(
          Expanded(child: Container(
            child: Text("${time}분",
              style: TextStyle(fontSize: 10,
                fontFamily: "NotoSans",
                color: Colors.black,),),
            margin: EdgeInsets.fromLTRB(5, 5, 3, 5),
          ))
      );
      //left line
      leftlines.add(
          Column(
            children: [
              Container(
                child: Text("${time}분",
                  style: TextStyle(fontSize: screenwidth*0.04,
                    fontFamily: "NotoSans",
                    color: Colors.black,),),
                margin: EdgeInsets.fromLTRB(6.5, 25, 3, 0.0),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(6.5, 5, 3, 5),
                child:  Icon(
                  icons[kind],
                  color: color,
                  size: 40,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(6.5, 5, 3, 3),
                width: 2.5,
                height: circle_num[i]!*screenwidth*0.06,
                color: color,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(6.5, 0.0, 3, 5),
                child: Icon(
                  Icons.circle,
                  color: color,
                  size: 15,
                ),
              )

            ],
          )
      );

    }
    Widget small =  GestureDetector(
      onTap: (){
        setState(() {
          _expanded = !_expanded;
        });
        print(_expanded);
      },
      child:Container(
        margin: EdgeInsets.fromLTRB(10, screenheight*0.65, 10, 0),
        width: screenwidth,
        height: screenheight,
        child: Container(
          width: screenwidth,
          height: screenwidth*0.35,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(screenwidth*0.1),
              topLeft: Radius.circular(screenwidth*0.1),
            )

          ),
          child: Container(
            alignment: Alignment.center,
            width: screenwidth,
            height: screenheight*0.25,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 15),
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 15),
                  child: Text("${_pathes.totaltime}분 ",
                    style:TextStyle(fontSize: 30,
                        fontFamily: "NotoSans",
                        color: Colors.black,
                        fontWeight: FontWeight.bold) ,),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: containers
                )
              ],
            ),
          ),
        ),
      ),
    );
    Widget big = Container(
      margin: EdgeInsets.fromLTRB(10, screenheight*0.2, 10, 0),
      width: screenwidth,
      child: Container(
        height: screenheight*0.9,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(screenwidth*0.1),
              topLeft: Radius.circular(screenwidth*0.1),
            )

        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: (){
                    setState(() {
                      _expanded = !_expanded;
                    });
                    print(_expanded);
                  },
                  child:Container(
                    alignment: Alignment.center,
                    width: screenwidth,
                    height: screenheight*0.15,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 15),
                          margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
                          child: Text("${_pathes.totaltime}분 ",
                            style:TextStyle(fontSize: 30,
                                fontFamily: "NotoSans",
                                color: Colors.black,
                                fontWeight: FontWeight.bold) ,),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: containers
                        )
                      ],
                    ),
                  ),
                ),
                Stack(
                  children: [
                    Column(
                      children: leftlines,
                    ),
                    Column(
                      children: rightdesc,
                    )
                  ],
                ),
              ],
            ),

          ),
        ),
      ),

    );
    var selectedchild;
    if (_expanded){
      selectedchild = big;
    }else{
      selectedchild = small;
    }
    return AnimatedCrossFade(
      duration: Duration(milliseconds: 500),
      // transitionBuilder: (Widget child, Animation<double> animation) {
      //   return ScaleTransition(child: child, scale: animation);
      // },
      // child: _expanded ? big : small,
      firstChild:small,
      secondChild:big,

      crossFadeState: _expanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      firstCurve: Interval(0.0,0.6,curve: Curves.fastOutSlowIn),
      secondCurve: Interval(0.4,1.0,curve: Curves.fastOutSlowIn),
    );
  }

}