import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/model_path.dart';

Widget make_description_horizontal(PathDetail _pathes, double height, double width,double fontsizescale){
  List<Widget> horizontalwidget = [];
  for (int index=0; index<_pathes.description.length; index++){
    horizontalwidget.add(_builddescList_horizon(_pathes.description[index], height*fontsizescale, width, index, fontsizescale));
  }
  return Container(
    height: height*0.15*fontsizescale,
    child: PageView(
      children: horizontalwidget,
    ),

  );
}

Widget make_description_vertical(PathDetail _pathes, double height, double width, double fontsizescale){
  return Container(
    height: height*0.5,
    child: Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.all(10),
            itemCount: _pathes.description.length,
            itemBuilder: (context,int index){
              return _builddescList(_pathes.description[index],height*fontsizescale,width,index,fontsizescale);
            },
            separatorBuilder: (context, int index){
              return const Divider();
            },
          ),
        ),
      ],

    ),

  );
}

Map icons = {'지하철': Icons.directions_subway,
  "버스": Icons.directions_bus,
  "도보": Icons.directions_walk,};
List sub_color = [Color(0xff0052a4),Color(0xff00a84d),Color(0xffef7c1c),Color(0xff00a5de),Color(0xff996cac),Color(0xffcd7c2f),
  Color(0xff747f00),Color(0xffe6186c),Color(0xffbdb092)];

Widget _builddescList(List<dynamic> desc, double screenheight, double screenwidth, int index, double fontsizescale) {
  var returndesc;
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
              margin: EdgeInsets.fromLTRB(20, 10, 5, 10),
              child:
              Icon(
                Icons.circle_outlined,
                color: color,
                size: screenwidth*0.04*fontsizescale,
              ),
            ),
            Container(
              child: Text("${stopby[i]}",
                style: TextStyle(fontSize: screenwidth*0.035*fontsizescale,
                  fontFamily: "NotoSans",
                  color: Colors.black,),
              ),
              margin: EdgeInsets.fromLTRB(10, 10, 5, 10),
            ),
          ],
        ),
      );
    }
    returndesc = Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  child: Icon(
                    icons[kind],
                    color: color,
                    size: 40*fontsizescale,
                  ),
                  margin: EdgeInsets.fromLTRB(0, 20, 5, 10),
                ),
                Container(
                  width: screenwidth*0.6,
                  child: Row(
                    children: [
                      Flexible(child: RichText(
                        maxLines: 3,
                        text: TextSpan(
                          text: "${start}",
                          style: TextStyle(fontSize: screenwidth*0.048*fontsizescale,
                              fontFamily: "NotoSans",
                              color: Colors.black,
                              fontWeight: FontWeight.bold),

                        ),
                      ),
                      )
                    ],
                  ) ,
                  margin: EdgeInsets.fromLTRB(10, 20, 5, 10),
                ),

              ],
            ),
            Container(
              child: Text("${stopbynum}개 역 이동",
                style: TextStyle(fontSize: screenwidth*0.04*fontsizescale,
                  fontFamily: "NotoSans",
                  color: Colors.black,),
              ),
              margin: EdgeInsets.fromLTRB(40, 5, 5, 10),
            ),
            // Container(
            //   child: Text("빠른 하차: ${fastout}",
            //     style: TextStyle(fontSize: screenwidth*0.04*fontsizescale,
            //       fontFamily: "NotoSans",
            //       color: Colors.black,),
            //   ),
            //   margin: EdgeInsets.fromLTRB(80, 5, 3, 5),
            // ),
            Column(
              children: subwaystops,
            ),
            Row(
              children: [
                Container(
                  child: Icon(
                    Icons.circle,
                    color: color,
                    size: 15*fontsizescale,
                  ),
                  margin: EdgeInsets.fromLTRB(10, 15, 5, 20),
                ),
                Container(
                  width: screenwidth*0.6,
                  child: Row(
                    children: [
                      Flexible(child: RichText(
                        maxLines: 3,
                        text: TextSpan(
                          text: "${stop}",
                          style: TextStyle(fontSize: screenwidth*0.048*fontsizescale,
                              fontFamily: "NotoSans",
                              color: Colors.black,
                              fontWeight: FontWeight.bold),

                        ),
                      ),
                      )
                    ],
                  ) ,
                  margin: EdgeInsets.fromLTRB(10, 15, 5, 20),
                ),
              ],
            ),
            // Container(
            //   child: Text("출구: ${out}",
            //     style: TextStyle(fontSize: screenwidth*0.04*fontsizescale,
            //       fontFamily: "NotoSans",
            //       color: Colors.black,),
            //   ),
            //   margin: EdgeInsets.fromLTRB(80, 5, 3, 5),
            // ),
          ],
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
      bus_soons.add(
          Row(
            children: [
              Container(
                child: Text("${bus_soon_num}",
                  style: TextStyle(fontSize: screenwidth*0.04*fontsizescale,
                    fontFamily: "NotoSans",
                    color: Colors.black,),
                ),
                margin: EdgeInsets.fromLTRB(40, 10, 5, 10),
              ),
              // Container(
              //   child: Text("${bus_soon_state}",
              //     style: TextStyle(fontSize: screenwidth*0.04*fontsizescale,
              //       fontFamily: "NotoSans",
              //       color: Colors.black,),
              //   ),
              //   margin: EdgeInsets.fromLTRB(2, 5, 3, 5),
              // )
            ],
          )
      );
    }

    for (int i=2; i<bus_stopby_num+1; i++){
      busstops.add(
        Row(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(20, 10, 5, 10),
              child:
              Icon(
                Icons.circle_outlined,
                color: color,
                size: screenwidth*0.035*fontsizescale,
              ),
            ),
            Container(
              child: Text("${bus[5][i]}",
                style: TextStyle(fontSize: screenwidth*0.035*fontsizescale,
                  fontFamily: "NotoSans",
                  color: Colors.black,),
              ),
              margin: EdgeInsets.fromLTRB(10, 10, 5, 10),
            ),
          ],
        ),
      );
    }
    returndesc =
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  child: Icon(
                    icons[kind],
                    color: color,
                    size: 40*fontsizescale,
                  ),
                  margin: EdgeInsets.fromLTRB(0, 20, 5, 10),
                ),
                Container(
                  width: screenwidth*0.6,
                  child: Row(
                    children: [
                      Flexible(child: RichText(
                        maxLines: 3,
                        text: TextSpan(
                          text: "${start}",
                          style: TextStyle(fontSize: screenwidth*0.048*fontsizescale,
                              fontFamily: "NotoSans",
                              color: Colors.black,
                              fontWeight: FontWeight.bold),

                        ),
                      ),
                      )
                    ],
                  ) ,
                  margin: EdgeInsets.fromLTRB(10, 20, 5, 10),
                ),
              ],
            ),
            Container(
              child: Text("${bus_stopby_num}개 정류소 이동",
                style: TextStyle(fontSize: screenwidth*0.04*fontsizescale,
                  fontFamily: "NotoSans",
                  color: Colors.black,),
              ),
              margin: EdgeInsets.fromLTRB(40, 5, 5, 10),
            ),
            Row(
              children: bus_soons,
            ),
            Column(
              children: busstops,
            ),
            Row(
              children: [
                Container(
                  child: Icon(
                    Icons.circle,
                    color: color,
                    size: 15*fontsizescale,
                  ),
                  margin: EdgeInsets.fromLTRB(10, 15, 5, 20),
                ),
                Container(
                  width: screenwidth*0.6,
                  child: Row(
                    children: [
                      Flexible(child: RichText(
                        maxLines: 3,
                        text: TextSpan(
                          text: "${stop}",
                          style: TextStyle(fontSize: screenwidth*0.048*fontsizescale,
                            fontFamily: "NotoSans",
                            color: Colors.black,
                            fontWeight: FontWeight.bold),

                        ),
                      ),
                      )
                    ],
                  ) ,
                  margin: EdgeInsets.fromLTRB(10, 15, 5, 20),
                ),
              ],
            ),

          ],
    );

  }
  var diricon = {"우회전": Icons.turn_left, "좌회전":Icons.turn_right, "직진":Icons.straight, "횡단보도": Icons.dehaze};
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
      if (direction == "직진"){
        walkdetail = "${meter} ${direction}하세요.";
      }else{
        walkdetail = "${direction} 후 ${meter} 이동하세요.";
      }
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

    returndesc =
        Row(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(5, 10, 0, 10),
              child:
              Icon(
                icons[kind],
                color: color,
                size: 25*fontsizescale,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child:
              Icon(
                diricon[direction],
                color: color,
                size: 30*fontsizescale,
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
                      style: TextStyle(fontSize: screenwidth*0.04*fontsizescale,
                        fontFamily: "NotoSans",
                        color: Colors.black,),

                    ),
                  ),
                  )
                ],
              ) ,

              margin: EdgeInsets.fromLTRB(15, 10, 10,10),
            ),
          ],
    );
  }
  return returndesc;
}

Widget _builddescList_horizon(List<dynamic> desc, double screenheight, double screenwidth, int index, double fontsizescale) {
  var returndesc;
  var kind = desc[0];
  var color = Colors.white10;
  if (kind == "지하철") {
    List<Widget> subwaystops = [];
    var subway = desc;
    var start = subway[2];
    var stop = subway[3];
    var subwaytime = subway[4];
    // var togo = subway[4];
    var subway_color = subway[1] - 1;
    color = sub_color[subway_color];

    // var fastout = desc[1].split("(")[1].split(")")[0].split("/");
    // var out = desc[1].split("(")[2].split(")")[0].split("/");
    var stopby = subway[5];
    var stopbynum = stopby[0];
    returndesc =
        Row(
          children: [
            Container(
              child: Icon(
                icons[kind],
                color: color,
                size: 30*fontsizescale,
              ),
              margin: EdgeInsets.fromLTRB(10, 5, 5, 0),
            ),
            Container(
              width: screenwidth * 0.25,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: RichText(
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      text: TextSpan(
                        text: "${start}",
                        style: TextStyle(fontSize: screenwidth * 0.045*fontsizescale,
                            fontFamily: "NotoSans",
                            color: Colors.black,),
                      ),
                    ),
                  )
                ],
              ) ,
              margin: EdgeInsets.fromLTRB(10, 5, 5, 0),
            ),
            Container(
              width: screenwidth * 0.15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: RichText(
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      text: TextSpan(
                        text: "${stopbynum}개 역 이동",
                        style: TextStyle(fontSize: screenwidth * 0.035*fontsizescale,
                            fontFamily: "NotoSans",
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ) ,
              margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
            ),
            Container(
              width: screenwidth * 0.25,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: RichText(
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      text: TextSpan(
                        text: "${stop}",
                        style: TextStyle(fontSize: screenwidth * 0.045*fontsizescale,
                            fontFamily: "NotoSans",
                            color: Colors.black,),
                      ),
                    ),
                  )
                ],
              ) ,
              margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
            ),
          ],
    );
  }
  if (kind == "버스") {
    color = Color(0xff0068b7);
    var bus = desc;
    var start = bus[2];
    var stop = bus[3];
    var bustime = bus[4];
    var bus_stopby_num = bus[5][0];

    returndesc =
            Row(
              children: [
                Container(
                  child: Icon(
                    icons[kind],
                    color: color,
                    size: 30*fontsizescale,
                  ),
                  margin: EdgeInsets.fromLTRB(10, 5, 5, 0),
                ),
                Container(
                  width: screenwidth * 0.25,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: RichText(
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          text: TextSpan(
                            text: "${start}",
                            style: TextStyle(fontSize: screenwidth * 0.045*fontsizescale,
                                fontFamily: "NotoSans",
                                color: Colors.black,),
                          ),
                        ),
                      )
                    ],
                  ) ,
                  margin: EdgeInsets.fromLTRB(10, 5, 5, 0),
                ),
                Container(
                  width: screenwidth * 0.15,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: RichText(
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          text: TextSpan(
                            text: "${bus_stopby_num}개 역 이동",
                            style: TextStyle(fontSize: screenwidth * 0.035*fontsizescale,
                                fontFamily: "NotoSans",
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ) ,
                  margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
                ),
                Container(
                  width: screenwidth * 0.25,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: RichText(
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            text: TextSpan(
                              text: "${stop}",
                              style: TextStyle(fontSize: screenwidth * 0.045*fontsizescale,
                                  fontFamily: "NotoSans",
                                  color: Colors.black,),
                            ),
                          ),
                        )
                      ],
                      ) ,
                  margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
                ),
              ],
        );
  }
  var diricon = {
    "우회전": Icons.turn_left,
    "좌회전": Icons.turn_right,
    "직진": Icons.straight,
    "횡단보도": Icons.dehaze
  };
  if (kind == "도보") {
    color = Colors.grey;
    var walk = desc;
    var direction = "";
    var meter = "";
    // var walk_time = "";
    var walk_descrip = "";
    var walkdetail = "";
    if (walk.length == 2) {
      direction = "직진";
      meter = walk[1];
      walkdetail = "${meter} ${direction}하세요.";
    }
    if (walk.length == 3) {
      direction = walk[1];
      meter = walk[2];
      // var walk_time = walk[3];
      if (direction == "직진"){
        walkdetail = "${meter} ${direction}하세요.";
      }else{
        walkdetail = "${direction} 후 ${meter} 이동하세요.";
      }
    }
    if (walk.length == 4) {
      direction = walk[1];
      meter = walk[3];
      // var walk_time = walk[2];
      walk_descrip = walk[2];
      walkdetail = "${direction} 후 ${walk_descrip}를 따라 ${meter} 이동하세요.";
    }
    if (direction == "횡단보도") {
      walkdetail = "${direction}를 건너세요.";
    }

    returndesc =
        Row(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(10, 5, 5, 0),
              child:
              Icon(
                icons[kind],
                color: color,
                size: 25*fontsizescale,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 5, 5, 0),
              child:
              Icon(
                diricon[direction],
                color: color,
                size: 30*fontsizescale,
              ),
            ),
            Container(
              width: screenwidth * 0.6,
              child: Row(
                children: [
                  Flexible(child: RichText(
                    maxLines: 3,
                    text: TextSpan(
                      text: walkdetail,
                      style: TextStyle(fontSize: screenwidth * 0.04*fontsizescale,
                        fontFamily: "NotoSans",
                        color: Colors.black,),

                    ),
                  ),
                  )
                ],
              ),
              margin: EdgeInsets.fromLTRB(10, 5, 5, 0),
            ),
          ],
        );
  }
  return returndesc;
}