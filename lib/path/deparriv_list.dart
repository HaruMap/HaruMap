
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../mainpage.dart';
import '../model/model_addr.dart';


class Departure extends StatefulWidget{
  List<AddrLoc> locs;
  bool start;
  bool stop;
  Departure({required this.locs, required this.start,required this.stop});
  @override
   _DepartureState createState() => _DepartureState();
}

class _DepartureState extends State<Departure> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    return WillPopScope(
        child: Scaffold(
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
          Get.off(MainPage());
          return Future(() => true);
        }
    );
  }

  bool flag = false;

  Widget _buildLocList(AddrLoc loc, double height, double width){
    return Container(
            padding: EdgeInsets.fromLTRB(10, 2, 10, 10),
            margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      flag = true;
                      print([widget.start,widget.stop,loc.lat,loc.lng ,loc.place_name]);
                      Get.to(MainPage(),arguments: [widget.start,widget.stop,loc.lat,loc.lng ,loc.place_name]);
                    },
                    child: Column(
                      children: [
                        Container(
                          child: Text("${loc.place_name}",
                            style: TextStyle(fontSize: 18),
                          ),
                          margin: EdgeInsets.fromLTRB(5, 0, 5, 10),
                        ),
                      ],
                    ),
                  ),
                ]
            )
        );
        }
  }



