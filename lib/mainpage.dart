
import 'dart:ffi';

import 'package:dio/dio.dart';
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
  @override
  _MainPageState createState() => _MainPageState();

}

var screenheight = 0.0;
var screenwidth = 0.0;
bool hasdep = false;
bool hasarrv = false;
bool startok = false;
bool stopok = false;
String startlabel = "";
String stoplabel = "";

class Controller extends GetxController{
  String startText = "";
  String stopText = "";

  void change(start,stop){
    startText = start;
    stopText = stop;
    update();
  }
}
class _MainPageState extends State<MainPage>{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String startText = "";
  String stopText = "";

  List<AddrLoc> locs = [];


  _loadLoc(loc) async {
    String baseUrl = "http://192.168.0.106:8000/haruapp/getloc?loc=${loc}";
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      setState(() {
        locs = parseAddrLoc(convert.utf8.decode(response.bodyBytes));
      });
    }else{
      throw Exception("failed to load data");
    }
  }

  @override
  Widget build(BuildContext context){
    screenheight = MediaQuery.of(context).size.height;
    screenwidth = MediaQuery.of(context).size.width;
    final controller = Get.put(Controller());
    startText = "";
    stopText = "";
    if (startok){
      startlabel = startlabel;
    } else{
      startlabel = "출발지";
    }
    if (stopok){
      stoplabel = stoplabel;
    } else{
      stoplabel = "도착지";
    }
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          key: _scaffoldKey,
          body: Container(
            child: GestureDetector(
              onTap: ()=> FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 15.0),
                      child: Column(
                          children: [
                            Padding(
                              child: TextField(
                                textInputAction: TextInputAction.go,
                                onSubmitted: (text) {
                                  startText = text;
                                  if (startText.isEmpty){
                                    showDialog(context: context,
                                    builder: (BuildContext buildcontext){
                                    return AlertDialog(
                                      content: Text("값을 입력해주세요"),
                                      actions: [
                                        Center(
                                          child: TextButton(
                                            child: Text('확인'),
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
                                      startok = true;
                                      return Navigator.push(context,
                                          MaterialPageRoute(
                                              builder: (context) => Departure(
                                                locs: locs,
                                                start: true,
                                                stop: false,
                                              )
                                          )
                                      );
                                    });

                                  }
                                },
                                decoration: InputDecoration(
                                    labelText: startlabel,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10.0))
                                    )
                                ),
                              ),
                              padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 5.0),
                            ),
                            Padding(
                                child: TextField(
                                  textInputAction: TextInputAction.go,
                                  onSubmitted: (text) async {
                                    stopText = text;
                                    if (stopText.isEmpty){
                                      showDialog(context: context,
                                          builder: (BuildContext buildcontext){
                                            return AlertDialog(
                                              content: Text("값을 입력해주세요"),
                                              actions: [
                                                Center(
                                                  child: TextButton(
                                                    child: Text('확인'),
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
                                                  locs: locs,
                                                  start: false,
                                                  stop: true,
                                                )
                                            )
                                        );
                                      });

                                    }
                                  },
                                  decoration: InputDecoration(
                                      labelText: stoplabel,
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(10.0))
                                      )
                                  ),
                                ),
                                padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 5.0)
                            ),
                            TextButton(onPressed:(){
                              if (startok && stopok){
                                controller.change(startText, stopText);
                                Get.to(TabPage());
                              }else{
                                showDialog(context: context,
                                    builder: (BuildContext buildcontext){
                                  return AlertDialog(
                                    content: Text("값을 입력해주세요"),
                                    actions: [
                                      Center(
                                        child: TextButton(
                                          child: Text('확인'),
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
                            }, child: Text("경로 찾기!"))
                          ]
                      ),
                    ),
                    KakaoMapshow(),
                  ],
                ),
              ),
            ),
          ),
        ),
        onWillPop: (){
          dep_ok = false;
          startok = false;
          startok = false;
          Get.offAll(SelectCasePage());
          return Future(() => true);
        }
    );
  }
}


bool dep_ok = false;
double hasarrv_lat = 37.556814718;
double hasarrv_lng = 126.94642;
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
      print("AAAAAAAAAAAAAa");
      print(["b",hasdep]);
      if(hasdep){
        hasdep_lat = Get.arguments[2];
        hasdep_lng =  Get.arguments[3];
        hasdep_name = Get.arguments[4];
        startlabel = hasdep_name;
        dep_ok = true;
      }
      hasarrv = Get.arguments[1];
      print(["arrvb",hasarrv]);
      if(hasarrv){
        hasarrv_lat = Get.arguments[2];
        hasarrv_lng = Get.arguments[3];
        hasarrv_name = Get.arguments[4];
        stoplabel = hasarrv_name;
      }
    }
    print(dep_ok);
    print(["dep",hasdep_lng]);
    print(["arr",hasarrv_lng]);

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
                  width: w * 0.9,
                  height: h * 0.7,
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
                      const dep_content = '<div class="customoverlay">' + '    <span class="title">$hasdep_name</span>' + '</div>';
                      var dep_customOverlay = new kakao.maps.CustomOverlay({
                              map: map,
                              position: marker1,
                              content: dep_content,
                              yAnchor: 1
                         
                          });
                      panTo($hasdep_lat,$hasdep_lng);
                     }
                    
                    }
                  
                  if ($hasarrv && complete_arrv){
                    addMarker(marker1);
                    bounds.extend(marker1);
                    const dep_content = '<div class="customoverlay" style="padding:5px;">' + '    <span class="title">$hasdep_name</span>' + '</div>';
                      var dep_customOverlay = new kakao.maps.CustomOverlay({
                              map: map,
                              position: marker1,
                              content: dep_content,
                              yAnchor: 2
                         
                          });
                          
                    
                    marker2 = new kakao.maps.LatLng($hasarrv_lat,$hasarrv_lng)
                    addMarker(marker2);
                    bounds.extend(marker2);
                    const arrv_content = '<div class="customoverlay" style="padding:5px;">' + '    <span class="title">$hasarrv_name</span>' + '</div>';
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
                  customOverlayStyle:
                    '''
                    <style>
                  .customoverlay {position:relative;bottom:85px;border-radius:6px;border: 1px solid #ccc;border-bottom:2px solid #ddd;float:left;}
                  .customoverlay: nth-of-type(n) {border:0; box-shadow:0px 1px 2px #888;} 
                  .customoverlay .title {display:block;text-align:center;background:#fff;margin-right:35px;padding:10px 15px;font-size:14px;font-weight:bold;}
                    </style>
                    ''',
                  customOverlay:
                    '''
                    var complete_dep_name = true;
                    var complete_arrv_name = true;
                    if ($dep_ok && complete_dep_name){
                        if (!$hasarrv){
                          const dep_content = '<div class="customoverlay">' + '    <span class="title">$hasdep_name</span>' + '</div>';
                          var position = new kakao.maps.LatLng($hasdep_lat,$hasdep_lng);
                      
                          var dep_customOverlay = new kakao.maps.CustomOverlay({
                              map: map,
                              position: position,
                              content: dep_content,
                              yAnchor: 1
                         
                          });
                        }
                    }
                    
                    if($hasarrv && complete_arrv_name){
                        if ($dep_ok){
                          const dep_content = '<div class="customoverlay">' +
                            '    <span class="title">$hasdep_name</span>' +
                            '</div>';
                            
                          var dep_position = new kakao.maps.LatLng($hasdep_lat,$hasdep_lng);
                      
                          var dep_customOverlay = new kakao.maps.CustomOverlay({
                              map: map,
                              position: dep_position,
                              content: dep_content,
                              yAnchor: 1
                         
                          });
                        }
                        const arrv_content = '<div class="customoverlay">' + '    <span class="title">$hasarrv_name</span>' + '</div>';
                             
                        
                        var position = new kakao.maps.LatLng($hasarrv_lat,$hasarrv_lng);
                    
                        var customOverlay = new kakao.maps.CustomOverlay({
                            map: map,
                            position: position,
                            content: arrv_content,
                            yAnchor: 1
                        });
                    }
                    ''',
                onTapMarker: (message) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(message.message)));
                      }

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
