
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:harumap2/pathdetail.dart';
import 'package:kakaomap_webview/kakaomap_webview.dart';



class PathInfoPage extends StatefulWidget{
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
          KakaoMapshow(),
        GestureDetector(
          onTap: (){
            Get.to(PathDetail(), transition: Transition.downToUp
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

}

class KakaoKey{
  String kakaokey;

  KakaoKey(this.kakaokey);

  factory KakaoKey.fromJson(Map<String,dynamic> parsedJson){
    return KakaoKey(
        parsedJson['key']
    );
  }
}

class KakaoMapshow extends StatelessWidget {
  final h = screenheight;
  final w = screenwidth;
  String kakaoMapKey = "";
  Future<String> _loadKeyAsset() async {
    return await rootBundle.loadString('assets/json/kakaojskey.json');
  }

  @override
  Widget build(BuildContext context) {
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
                    lat: 33.450701,
                    lng: 126.570667,
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


