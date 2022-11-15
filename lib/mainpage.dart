
import 'dart:ffi';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:harumap2/model/getpath_api_adapter.dart';
import 'package:harumap2/model/model_path.dart';
import 'package:harumap2/path/deparriv_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:harumap2/path_list.dart';
import 'package:harumap2/selectcase.dart';
import 'package:kakaomap_webview/kakaomap_webview.dart';

import 'model/model_addr.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../model/getaddr_api_adapter.dart';


class MainPage extends StatefulWidget{
  String selectedcase;
  MainPage({required this.selectedcase});
  @override
  _MainPageState createState() => _MainPageState();

}

var screenheight = 0.0;
var screenwidth = 0.0;
bool hasdep = false;
bool hasarrv = false;
bool startok = false;
bool stopok = false;
String dep = "";
String arrv = "";

TextEditingController _depController = TextEditingController( text: " ");
TextEditingController _arrvController = TextEditingController( text: " ");

class _MainPageState extends State<MainPage>{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();



  String startText = "";
  String stopText = "";

  List<AddrLoc> locs = [];
  List<PathDetail> pathes = [];
  String orders = "0";

  Future<String> _loadKeyAsset() async {
    return await rootBundle.loadString('assets/json/kakaorestapi.json');
  }

  _loadLoc(loc) async {
    String REST_API_KEY = await _loadKeyAsset();
    REST_API_KEY = REST_API_KEY.split(":")[1].split("}")[0].split("\"")[1];
    String baseUrl = "";//"https://dapi.kakao.com/v2/local/search/keyword.json?page=1&size=15&sort=accuracy&query=${loc}";
    print(REST_API_KEY);
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {HttpHeaders.authorizationHeader: "KakaoAK ${REST_API_KEY}"},
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      setState(() {
        locs = parseAddrLoc(convert.utf8.decode(response.bodyBytes));
      });
    }else{
      throw Exception("failed to load data");
    }
  }

  _loadPath(deplat,deplng,arrvlat,arrvlng) async {
    String baseUrl = "http://192.168.0.103:8000/haruapp/getPathes?user=${widget.selectedcase}&orders=${orders}&deplat=${deplat}&deplng=${deplng}&arrvlat=${arrvlat}&arrvlng=${arrvlng}";
    print(baseUrl);
    final response = await http.get(
      Uri.parse(baseUrl),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      setState(() {
        pathes = parsePathes(convert.utf8.decode(response.bodyBytes));
      });
    }else{
      throw Exception("failed to load data");
    }
  }
  // @override
  // void dispose() {
  //   _depController.dispose();
  //   _arrvController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context){
    screenheight = MediaQuery.of(context).size.height;
    screenwidth = MediaQuery.of(context).size.width;
    startText = "";
    stopText = "";

    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return WillPopScope(
        child: Scaffold(
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
          resizeToAvoidBottomInset: false,
          key: _scaffoldKey,
          body: Container(
            margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            child: GestureDetector(
              onTap: ()=> FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                child: Column(
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
                                    controller: _depController,
                                    textInputAction: TextInputAction.go,
                                    onSubmitted: (text) {
                                      startText = text;
                                      if (startText.isEmpty || startText == " "){
                                        showDialog(context: context,
                                            builder: (BuildContext buildcontext){
                                              return AlertDialog(
                                                content: SizedBox(
                                                    height: screenheight*0.1,
                                                    child:Center(
                                                      child: Text("값을 입력해주세요",
                                                          style: TextStyle(fontSize: screenwidth*0.045,
                                                            fontFamily: "NotoSans",
                                                            color: Colors.black,)),
                                                    )
                                                ),
                                                actions: [
                                                  Center(
                                                    child: TextButton(
                                                      child: Text('확인',
                                                          style: TextStyle(fontSize: screenwidth*0.045,
                                                            fontFamily: "NotoSans",
                                                            color: Colors.black,)),
                                                      onPressed: (){
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                  )
                                                ],
                                              );
                                            });
                                      }
                                      else {
                                        _loadLoc(startText).whenComplete((){
                                          print(locs);
                                          startok = true;
                                          return Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) => Departure(
                                                    selectedcase: widget.selectedcase,
                                                    locs: locs,
                                                    query: startText,
                                                    start: true,
                                                    stop: false,
                                                    controller: _depController,
                                                  )
                                              )
                                          );
                                        });

                                      }
                                    },
                                    decoration: InputDecoration(
                                        labelText: _depController.text,
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
                                  controller: _arrvController,
                                  textInputAction: TextInputAction.go,
                                  onSubmitted: (text) async {
                                    stopText = text;
                                    if (stopText.isEmpty || stopText == " "){
                                      showDialog(context: context,
                                          builder: (BuildContext buildcontext){
                                            return AlertDialog(
                                              content: SizedBox(
                                                  height: screenheight*0.1,
                                                  child: Center(
                                                    child: Text("값을 입력해주세요",
                                                        style: TextStyle(fontSize: screenwidth*0.045,
                                                          fontFamily: "NotoSans",
                                                          color: Colors.black,)),
                                                  )
                                              ),
                                              actions: [
                                                Center(
                                                  child: TextButton(
                                                    child: Text('확인',
                                                        style: TextStyle(fontSize: screenwidth*0.045,
                                                          fontFamily: "NotoSans",
                                                          color: Colors.black,)),
                                                    onPressed: (){
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                )
                                              ],
                                            );
                                          });
                                    }else {
                                      _loadLoc(stopText).whenComplete((){
                                        stopok = true;
                                        return Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) => Departure(
                                                  selectedcase: widget.selectedcase,
                                                  locs: locs,
                                                  query: stopText,
                                                  start: false,
                                                  stop: true,
                                                  controller: _arrvController,
                                                )
                                            )
                                        );
                                      });

                                    }
                                  },
                                  decoration: InputDecoration(
                                      labelText: _arrvController.text,
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
                    // KakaoMapshow(),
                    Container(
                      margin: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                      child:TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Color.fromARGB(233, 94, 208, 184),
                          ),
                          onPressed:(){
                            if (startok && stopok){
                              _loadPath(hasdep_lat,hasdep_lng,hasarrv_lat,hasarrv_lng).whenComplete((){
                                return Navigator.push(context,
                                    MaterialPageRoute(
                                        builder: (context) => TabPage(
                                          selectedcase: widget.selectedcase,
                                          path: pathes,
                                          dep: _depController.text,
                                          dep_lat: hasdep_lat,
                                          dep_lng: hasdep_lng,
                                          arrv: _arrvController.text,
                                          arrv_lat: hasarrv_lat,
                                          arrv_lng: hasarrv_lng,
                                          dep_controller: _depController,
                                          arrv_controller: _arrvController,
                                          orders: orders,
                                        )
                                    )
                                );
                              });
                            }else{
                              showDialog(context: context,
                                  builder: (BuildContext buildcontext){
                                    return AlertDialog(
                                      content: SizedBox(
                                          height: screenheight*0.1,
                                          child:Center(
                                            child: Text("값을 입력해주세요",
                                                style: TextStyle(fontSize: screenwidth*0.045,
                                                  fontFamily: "NotoSans",
                                                  color: Colors.black,)),
                                          )
                                      ),
                                      actions: [
                                        Center(
                                          child: TextButton(
                                            child:Text('확인',
                                                style: TextStyle(fontSize: screenwidth*0.045,
                                                  fontFamily: "NotoSans",
                                                  color: Colors.black,
                                                )
                                            ),
                                            onPressed: (){
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        )
                                      ],
                                    );
                                  }
                              );
                            }
                          }, child: Container(
                              width: screenwidth * 0.85,
                              height: screenheight * 0.05,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(screenwidth*0.4),
                              ),
                              child: Center(
                                child: Text("경로 확인!",
                                    style: TextStyle(fontSize: screenwidth*0.048,
                                      fontFamily: "NotoSans",
                                      color: Colors.white,
                                        fontWeight: FontWeight.bold)
                          ),
                        ),
                      )
                      ) ,
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),
        onWillPop: (){
          dep_ok = false;
          arrv_ok = false;
          startok = false;
          stopok = false;
          _depController.text= " ";
          _arrvController.text= " ";
          Get.offAll(SelectCasePage());
          return Future(() => true);
        }
    );
  }
}


bool arrv_ok = false;
bool dep_ok = false;
double hasarrv_lat = 37.56;
double hasarrv_lng = 126.9;
String hasarrv_name = "";

double hasdep_lat = 37.556814718;
double hasdep_lng = 126.94642;
String hasdep_name = "";

class KakaoMapshow extends StatelessWidget {
  final h = screenheight;
  final w = screenwidth;
  String kakaoMapKey = "";
  Future<String> _loadKeyAsset() async {
    return await rootBundle.loadString('assets/json/kakaojskey.json');
  }
  @override
  Widget build(BuildContext context) {
    if (Get.arguments != null){
      hasdep = Get.arguments[0];
      if(hasdep){
        hasdep_lat = Get.arguments[2];
        hasdep_lng =  Get.arguments[3];
        hasdep_name = Get.arguments[4];
        dep_ok = true;

      }
      hasarrv = Get.arguments[1];
      if(hasarrv){
        hasarrv_lat = Get.arguments[2];
        hasarrv_lng = Get.arguments[3];
        hasarrv_name = Get.arguments[4];
        arrv_ok = true;
      }
    }

    return FutureBuilder<String>(
      future: _loadKeyAsset(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot){
        if (snapshot.hasData){
          kakaoMapKey = snapshot.data!.split(":")[1].split("}")[0].split("\"")[1] as String;
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                child: KakaoMapView(
                  width: w,
                  height: h * 0.5,
                  kakaoMapKey: kakaoMapKey,
                  lat: 33.450701,
                  lng: 126.570667,
                  showMapTypeControl: true,
                  showZoomControl: true,
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
                  if ($dep_ok && complete_dep){
                    var marker1 = new kakao.maps.LatLng(${hasdep_lat},${hasdep_lng});
                    if(!$hasarrv){
                      addMarker(marker1);
                      bounds.extend(marker1);
                      const dep_content = '<div class="customoverlay">' + '    <span style ="display:block;text-align:center;background:#fff;margin-right:35px;padding:10px 15px;font-size:14px;font-weight:bold;border-radius:6px;border: 1px solid #ccc;border-bottom:2px solid #ddd; box-shadow:0px 1px 2px #888;" >$hasdep_name</span>' + '</div>';
                      var dep_customOverlay = new kakao.maps.CustomOverlay({
                              map: map,
                              position: marker1,
                              content: dep_content,
                              yAnchor: 2
                         
                          });
                      panTo($hasdep_lat,$hasdep_lng);
                     }
                    
                    }
                  
                  if ($arrv_ok && complete_arrv){
                    marker2 = new kakao.maps.LatLng($hasarrv_lat,$hasarrv_lng)
                    if(!$hasdep){
                      addMarker(marker2);
                      bounds.extend(marker2);
                      const arrv_content = '<div class="customoverlay" style="padding:5px;">' + '    <span style="display:block;text-align:center;background:#fff;margin-right:35px;padding:10px 15px;font-size:14px;font-weight:bold;border-radius:6px;border: 1px solid #ccc;border-bottom:2px solid #ddd; box-shadow:0px 1px 2px #888;">$hasarrv_name</span>' + '</div>';
                      var dep_customOverlay = new kakao.maps.CustomOverlay({
                              map: map,
                              position: marker2,
                              content: arrv_content,
                              yAnchor: 2
                         
                          });
                      panTo($hasarrv_lat,$hasarrv_lng);
                      }
                   }
                   
                  if ($dep_ok && $arrv_ok){
                    addMarker(marker1);
                    bounds.extend(marker1);
                                        
                    addMarker(marker2);
                    bounds.extend(marker2);
                    const dep_content = '<div class="customoverlay" style="padding:5px;">' + '    <span style ="display:block;text-align:center;background:#fff;margin-right:35px;padding:10px 15px;font-size:14px;font-weight:bold;border-radius:6px;border: 1px solid #ccc;border-bottom:2px solid #ddd; box-shadow:0px 1px 2px #888;" >$hasdep_name</span>' + '</div>';
                      var dep_customOverlay = new kakao.maps.CustomOverlay({
                              map: map,
                              position: marker1,
                              content: dep_content,
                              yAnchor: 2
                         
                          });
                    
                    const arrv_content = '<div class="customoverlay" style="padding:5px;">' + '    <span style ="display:block;text-align:center;background:#fff;margin-right:35px;padding:10px 15px;font-size:14px;font-weight:bold;border-radius:6px;border: 1px solid #ccc;border-bottom:2px solid #ddd; box-shadow:0px 1px 2px #888;" >$hasarrv_name</span>' + '</div>';
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
                    }
                    
                    function panTo(lat,lng) {
                        var moveLatLon = new kakao.maps.LatLng(lat,lng);
                        
                        map.panTo(moveLatLon);            
                    }   
                    function setBounds() {
                        map.setBounds(bounds);
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
