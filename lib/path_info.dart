
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:harumap2/pathdetail.dart';
import 'package:kakaomap_webview/kakaomap_webview.dart';

import 'model/model_path.dart';



class PathInfoPage extends StatefulWidget{

  List<PathDetail> path;
  String dep;
  double dep_lat;
  double dep_lng;
  String arrv;
  double arrv_lat;
  double arrv_lng;
  PathInfoPage({required this.path, required this.dep, required this.dep_lat, required this.dep_lng, required this.arrv, required this.arrv_lat, required this.arrv_lng});

  @override
  _PathInfoState createState() => _PathInfoState();
}

class _PathInfoState extends State<PathInfoPage>{
  @override
  Widget build(BuildContext context) {
    screenheight = MediaQuery.of(context).size.height;
    screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          _showdescription(context),
        GestureDetector(
          onTap: (){
            Get.to(PathDesc(), transition: Transition.downToUp
            );
          },
          child: Container(
            alignment: Alignment.bottomCenter,
          height: screenheight*0.2,
          width: screenwidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.orange,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 7,
                offset: Offset(1,3),
              )
            ],
          ),
            child: Text("aaa"),
        )
        )
        ],
      )
    );
  }

  String kakaoMapKey = "";
  Future<String> _loadKeyAsset() async {
    return await rootBundle.loadString('assets/json/kakaojskey.json');
  }

  final h = screenheight;
  final w = screenwidth;

  @override
  Widget _showdescription(BuildContext context) {
    return FutureBuilder<String>(
        future: _loadKeyAsset(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot){
          if (snapshot.hasData){
            kakaoMapKey = snapshot.data!.split(":")[1].split("}")[0].split("\"")[1] as String;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                  child: KakaoMapView(
                    width: w * 0.9,
                    height: h * 0.75,
                    kakaoMapKey: kakaoMapKey,
                    lat: widget.dep_lat,
                    lng: widget.dep_lng,
                    showMapTypeControl: true,
                    showZoomControl: true,
                    draggableMarker: true,
                    polyline: KakaoFigure(
                      path: [
                        KakaoLatLng(lat: 33.45080604081833, lng: 126.56900858718982),
                        KakaoLatLng(lat: 33.450766588506054, lng: 126.57263147947938),
                        KakaoLatLng(lat: 33.45162008091554, lng: 126.5713226693152)
                      ],
                      strokeColor: Colors.blue,
                      strokeWeight: 2.5,
                      strokeColorOpacity: 0.9,
                    ),
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
                  var marker1 = new kakao.maps.LatLng(${widget.dep_lat},${widget.dep_lng});
                  var marker2 = new kakao.maps.LatLng(${widget.arrv_lat},${widget.arrv_lng});
                    
                  addMarker(marker1);
                  bounds.extend(marker1);
                  const dep_content = '<div class="customoverlay" style="padding:5px;">' + '    <span class="title">${widget.dep}</span>' + '</div>';
                    var dep_customOverlay = new kakao.maps.CustomOverlay({
                            map: map,
                            position: marker1,
                            content: dep_content,
                            yAnchor: 2
                       
                        });
                    
                  addMarker(marker2);
                  bounds.extend(marker2);
                  const arrv_content = '<div class="customoverlay" style="padding:5px;">' + '    <span class="title">${widget.arrv}</span>' + '</div>';
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


