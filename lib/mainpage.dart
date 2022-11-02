import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harumap2/path_list.dart';
import 'package:flutter/services.dart';
import 'package:harumap2/selectcase.dart';
import 'package:kakaomap_webview/kakaomap_webview.dart';

class MainPage extends StatefulWidget{
  @override
  _MainPageState createState() => _MainPageState();

}

var screenheight = 0.0;
var screenwidth = 0.0;

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
  String startText = "";
  String stopText = "";

  @override
  Widget build(BuildContext context){
    screenheight = MediaQuery.of(context).size.height;
    screenwidth = MediaQuery.of(context).size.width;
    final controller = Get.put(Controller());
    startText = "";
    stopText = "";
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
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
                                textInputAction: TextInputAction.next,
                                onChanged: (text) {
                                  startText = text;
                                },
                                decoration: InputDecoration(
                                    labelText: "출발지",
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
                                    if (startText.isEmpty || stopText.isEmpty){
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
                                      controller.change(startText, stopText);
                                      print(startText);
                                      print(stopText);
                                      Get.to(PathListPage(), arguments: [startText,stopText]);
                                    }
                                  },
                                  decoration: InputDecoration(
                                      labelText: "도착지",
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(10.0))
                                      )
                                  ),
                                ),
                                padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 5.0)
                            ),
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
          Get.offAll(SelectCasePage());
          return Future(() => true);
        }
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

  // Future loadKey() async {
  //   String jsonString = await _loadKeyAsset();
  //   final jsonResponse = json.decode(jsonString);
  //   KakaoKey key = new KakaoKey.fromJson(jsonResponse);
  //   print("Aaaaaaaaaaaaa");
  //   print(key.kakaokey);
  //   kakaoMapKey = key.kakaokey;
  // }
  @override
  Widget build(BuildContext context) {
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
