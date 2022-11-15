
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../mainpage.dart';
import '../model/getaddr_api_adapter.dart';
import '../model/model_addr.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


class Departure extends StatefulWidget{
  List<AddrLoc> locs;
  String query;
  bool start;
  bool stop;
  TextEditingController controller;
  String selectedcase;
  Departure({required this.locs,required this.query,required this.selectedcase, required this.start,required this.stop, required this.controller});
  @override
   _DepartureState createState() => _DepartureState();
}

class _DepartureState extends State<Departure> {
  List<AddrLoc> locs = [];

  Future<String> _loadKeyAsset() async {
    return await rootBundle.loadString('assets/json/kakaorestapi.json');
  }

  _loadLoc(loc) async {
    String REST_API_KEY = await _loadKeyAsset();
    REST_API_KEY = REST_API_KEY.split(":")[1].split("}")[0].split("\"")[1];
    String baseUrl = "https://dapi.kakao.com/v2/local/search/keyword.json?page=1&size=15&sort=accuracy&query=${loc}";
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

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    String devarrvText = "";
    return WillPopScope(
        child: Scaffold(
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
          body: SingleChildScrollView(
            child: Container(
              height: height,
              width: width,
              child: Column(
                children: <Widget>[
                  Container(
                    height: height*0.15,
                    color: Color.fromARGB(255, 245, 245, 245),
                    child:
                    TextField(
                        controller: widget.controller,
                        textInputAction: TextInputAction.go,
                        onSubmitted: (text) {
                          devarrvText = text;
                          if (devarrvText.isEmpty || devarrvText == " "){
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
                            _loadLoc(devarrvText).whenComplete((){
                              print(locs);
                              startok = true;
                              return Navigator.push(context,
                                  MaterialPageRoute(
                                      builder: (context) => Departure(
                                        selectedcase: widget.selectedcase,
                                        locs: locs,
                                        query: devarrvText,
                                        start: true,
                                        stop: false,
                                        controller: widget.controller,
                                      )
                                  )
                              );
                            });

                          }
                        },
                        decoration: InputDecoration(
                          labelText: widget.controller.text,
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
                    padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                  ),
                  Container(
                    height: height*0.7,
                    width: width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 8.0),
                          margin: EdgeInsets.fromLTRB(20.0, 15.0, 15.0, 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(screenwidth*0.4),
                            color: Color.fromARGB(233, 94, 208, 184),
                          ),
                          child: Text("검색 결과",
                                style: TextStyle(fontSize: screenwidth*0.04,
                                    fontFamily: "NotoSans",
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)
                            ),

                        ),
                        Expanded(
                          child: ListView.separated(
                            padding: EdgeInsets.all(8),
                            itemCount: widget.locs.length,
                            itemBuilder: (context,int index){
                              return _buildLocList( widget.locs[index],height,width);
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
          Get.off(MainPage(
            selectedcase: widget.selectedcase,
          ));
          return Future(() => true);
        }
    );
  }

  bool flag = false;

  Widget _buildLocList(AddrLoc loc, double height, double width){
    String address = "";
    if (loc.road_address_name.isEmpty){
      address = loc.address_name;
    }else{
      address = loc.road_address_name;
    }
    return Container(
            padding: EdgeInsets.fromLTRB(10, 2, 10, 10),
            margin: EdgeInsets.fromLTRB(10, 5, 0, 5),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      flag = true;
                      widget.controller.text = loc.place_name;
                      print([widget.start,widget.stop,double.parse(loc.lat),double.parse(loc.lng),loc.place_name]);
                      Get.to(MainPage(
                        selectedcase: widget.selectedcase,
                      ),arguments: [widget.start,widget.stop,double.parse(loc.lat),double.parse(loc.lng) ,loc.place_name]);
                    },
                    child: Column(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Color.fromARGB(233, 94, 208, 184),
                                size: screenwidth*0.08,
                              ),
                              Container(
                                width: width*0.7,
                                padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${loc.place_name}",
                                        style: TextStyle(fontSize: screenwidth*0.05,
                                          fontFamily: "NotoSans",
                                          fontWeight: FontWeight.bold,),
                                      textScaleFactor: 1.0,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    Text("",style: TextStyle(fontSize:  screenwidth*0.01),),
                                    Text("${address}",
                                        style: TextStyle(fontSize: screenwidth*0.035,
                                          fontFamily: "NotoSans",
                                          color: Colors.grey,),
                                      textScaleFactor: 1.0,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                          margin: EdgeInsets.fromLTRB(0, 0, 5, 5),
                        ),
                      ],
                    ),
                  ),
                ]
            )
        );
        }
  }



