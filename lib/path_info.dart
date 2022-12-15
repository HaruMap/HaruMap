
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kakaomap_webview/kakaomap_webview.dart';

import 'mainpage.dart';
import 'model/model_path.dart';
import 'path/path_info_descrip.dart';
import 'selectcase.dart';



class PathInfoPage extends StatefulWidget{

  PathDetail path;
  String dep;
  double dep_lat;
  double dep_lng;
  String arrv;
  double arrv_lat;
  double arrv_lng;
  List<dynamic> corcolor;
  String selectedcase;
  PathInfoPage({required this.path, required this.dep, required this.dep_lat,
    required this.dep_lng, required this.arrv, required this.arrv_lat, required this.arrv_lng,
    required this.corcolor, required this.selectedcase});

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
var screenheight;
var screenwidth;

var fontsizescale = 1.0;
class _PathInfoState extends State<PathInfoPage>{

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    fontsizescale = 1.0;
    if(widget.selectedcase == "0"){
      fontsizescale = 1.3;
    }
    path = widget.path;
    dep = widget.dep;
    dep_lat = widget.dep_lat;
    dep_lng = widget.dep_lng;
    arrv = widget.arrv;
    arrv_lat = widget.arrv_lat;
    arrv_lng = widget.arrv_lng;
    screenheight = MediaQuery.of(context).size.height;
    screenwidth = MediaQuery.of(context).size.width;
    var pastkind = path.coor[0][0];
    var tmpcor = [];
    kakaocor = [];
    var subwaynum;
    var pastsubwaynum;
    var j = path.coor.length;
    tmpcor.add([path.coor[0][2],path.coor[0][1]]);
    for (int i=1; i<path.coor.length; i++){
      var cor = path.coor[i];
      var kind = cor[0];
      print(cor.length);
      if (cor.length == 4){
        print(subwaynum);
        subwaynum = cor[3];
        if (i < j){
          pastsubwaynum = subwaynum;
          print(pastsubwaynum);
        }
      }
      if (kind != pastkind){
        kakaocor.add(tmpcor);
        tmpcor = [];
        tmpcor.add([cor[2],cor[1]]);
        pastkind = kind;
      } else{
        if(cor.length == 4){
          if(subwaynum != pastsubwaynum){
            kakaocor.add(tmpcor);
            tmpcor = [];
            tmpcor.add([cor[2],cor[1]]);
            pastsubwaynum = subwaynum;
          }
          else{
            tmpcor.add([cor[2],cor[1]]);
          }
        }
        else{
          tmpcor.add([cor[2],cor[1]]);
        }
      }
      if (i == path.coor.length -1 && tmpcor.length > 0){
        kakaocor.add(tmpcor);
      }

    }
    print(kakaocor.length);
    return WillPopScope(
      child: Scaffold(
          backgroundColor: Color.fromARGB(255, 245, 245, 245),
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
            title: Text("하루지도",
              style: TextStyle(fontSize: screenwidth*0.06,
                  fontFamily: "NotoSans",
                  color: Color.fromARGB(233, 94, 208, 184),
                  fontWeight: FontWeight.bold),
              textScaleFactor: 1.0,
              overflow: TextOverflow.ellipsis,
            ),
            centerTitle: true,
            leading:  IconButton(
                onPressed: () {
                  _expanded = true;
                  Navigator.pop(context);
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
                        _expanded = true;
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
          body: Stack(
            children: [
              _showmap(context),
              detaildescription(pathes: path) ,

            ],
          )
      ),
      onWillPop: ()  {
        _expanded = true;
        return Future(() => true); //뒤로가기 막음
      },
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
    List<Widget> containers = [];

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
        Row(
          children: [
            Container(
              height: screenheight*0.1*fontsizescale,
              child: Icon(
                icons[kind],
                color: color,
                size: 25*fontsizescale,
              ),
              margin: EdgeInsets.fromLTRB(5, 10*fontsizescale, 5, 5),
            ),
            Container(
              height: screenheight*0.1*fontsizescale,
              child: Text("${time}분",
                style: TextStyle(fontSize: 15*fontsizescale,
                  fontFamily: "NotoSans",
                  color: Colors.black,),),
              margin: EdgeInsets.fromLTRB(5, 20*fontsizescale, 5, 5),
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
      },
      child:Container(
        margin: EdgeInsets.fromLTRB(10, screenheight*(0.54/fontsizescale), 10, 0),
        width: screenwidth,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(screenwidth*0.1),
              topLeft: Radius.circular(screenwidth*0.1),
            )

          ),
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 3),
                  child: Text("${_pathes.totaltime.toInt()}분 ",
                    style:TextStyle(fontSize: 30*fontsizescale,
                        fontFamily: "NotoSans",
                        color: Colors.black,
                        fontWeight: FontWeight.bold) ,),
                ),
                Container(
                  height: screenheight*0.1*fontsizescale,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ListView.separated(
                            padding: EdgeInsets.all(5),
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
                make_description_horizontal(_pathes, screenheight, screenwidth,fontsizescale)
              ],
            ),
          ),
        ),
      ),
    );
    Widget big = GestureDetector(
      onTap: (){
        setState(() {
          _expanded = !_expanded;
        });
      },
      child:Container(
        margin: EdgeInsets.fromLTRB(10, screenheight*0.15, 10, 0),
        width: screenwidth,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(screenwidth*0.1),
                topLeft: Radius.circular(screenwidth*0.1),
              )

          ),
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 3),
                  child: Text("${_pathes.totaltime.toInt()}분 ",
                    style:TextStyle(fontSize: 30*fontsizescale,
                        fontFamily: "NotoSans",
                        color: Colors.black,
                        fontWeight: FontWeight.bold) ,),
                ),
                Container(
                  height: screenheight*0.1*fontsizescale,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ListView.separated(
                            padding: EdgeInsets.all(5),
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
                make_description_vertical(_pathes, screenheight, screenwidth,fontsizescale)
              ],
            ),
          ),
        ),
      ),
    );

    return AnimatedCrossFade(
      duration: Duration(milliseconds: 500),
      // transitionBuilder: (Widget child, Animation<double> animation) {
      //   return ScaleTransition(child: child, scale: animation);
      // },
      // child: _expanded ? big : small,
      firstChild:small,
      secondChild: big,

      crossFadeState: _expanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      firstCurve: Interval(0.0,0.6,curve: Curves.fastOutSlowIn),
      secondCurve: Interval(0.4,1.0,curve: Curves.fastOutSlowIn),
    );
  }

}