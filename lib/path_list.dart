import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class PathListPage extends StatefulWidget {

  @override
  _PathListPageState createState() => _PathListPageState();

}

class Pathes{
  int time;
  String start;
  String stop;
  List<String> pathes;

  Pathes(this.time,this.start,this.stop,this.pathes);
}

String startText = Get.arguments[0];
String stopText = Get.arguments[1];
List<String> pathdetail = <String>['a','b','c'];
List pathes = [
      Pathes(10, startText, stopText, pathdetail),
      Pathes(10, startText, stopText, pathdetail),
      Pathes(10, startText, stopText, pathdetail),
      Pathes(10, startText, stopText, pathdetail),
];

class _PathListPageState extends State<PathListPage>{

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
            Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Text('$startText'),
                // Text('$stopText'),
                // Default(),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.all(8),
                    itemCount: pathes.length+1,
                    itemBuilder: (context,int index){
                      if (index == 0) return Default();
                      return PathList(pathes[index-1]);
                    },
                    separatorBuilder: (context, int index){
                      if (index==0) return SizedBox.shrink();
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
    );
  }
}

class PathList extends StatelessWidget{
  PathList(this._pathes);
  final Pathes _pathes;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Container(
        child: ListTile(
          title: Text("${_pathes.start} ~ ${_pathes.stop}"),
          leading: SizedBox(
            height: 50,
            width: 50,
          ),
        )
    );
  }
}

class Default extends StatefulWidget{
  @override
  _DefaultState createState() => _DefaultState();
}

class _DefaultState extends State<Default> {
  String newstartText = "";
  String newstopText = "";

  void _anotherpath(){
    setState(() {
      if (newstartText.isEmpty || newstopText.isEmpty) {
        showDialog(context: context,
            builder: (BuildContext buildcontext) {
              return AlertDialog(
                content: Text("값을 입력해주세요"),
                actions: [
                  Center(
                    child: TextButton(
                      child: Text('확인'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                ],
              );
            });
      }
      else {
        print("??");
        startText = newstartText;
        stopText = newstopText;
        pathes = [
          Pathes(10, startText, stopText, pathdetail),
          Pathes(10, startText, stopText, pathdetail),
          Pathes(10, startText, stopText, pathdetail),
          Pathes(10, startText, stopText, pathdetail),
        ];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    var screenwidth = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          child: TextField(
            textInputAction: TextInputAction.next,
            onSubmitted: (text) {
              newstartText = text;
            },
            decoration: InputDecoration(
                labelText: " $startText",
                labelStyle: TextStyle(
                    fontSize: screenwidth*0.045,
                    fontFamily: "NanumSquare"
                ),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                )
            ),
          ),
          padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 5.0),
        ),
        Padding(
            child: TextField(
              textInputAction: TextInputAction.go,
              onSubmitted: (text) {
                newstopText = text;
                _anotherpath();
              },
              decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelText: " $stopText",
                  labelStyle: TextStyle(
                      fontSize: screenwidth*0.045,
                      fontFamily: "NanumSquare"
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                  )
              ),
            ),
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 5.0)
        ),
      ],
      // ),
    );
  }
}

