import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harumap2/mainpage.dart';


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

String startText = "";
String stopText = "";
bool Flag = false;
String newstartText = "";
String newstopText = "";
List<String> pathdetail = <String>['a','b','c'];
List pathes = [];

class _PathListPageState extends State<PathListPage>{
  @override
  Widget build(BuildContext context) {
    print(newstopText);
    print(newstartText);
    print("AAAA");
    print(stopText);
    print(startText);
    if (Flag){
      pathes = [
        Pathes(10, newstartText, newstopText, pathdetail),
        Pathes(10, newstartText, newstopText, pathdetail),
        Pathes(10, newstartText, newstopText, pathdetail),
        Pathes(10, newstartText, newstopText, pathdetail),
      ];
    }else{
      startText = Get.find<Controller>().startText;
      stopText = Get.find<Controller>().stopText;
      pathes = [
        Pathes(10, startText, stopText, pathdetail),
        Pathes(10, startText, stopText, pathdetail),
        Pathes(10, startText, stopText, pathdetail),
        Pathes(10, startText, stopText, pathdetail),
      ];
    }
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return WillPopScope(
        child:Scaffold(
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
        ),
        onWillPop: (){
          Flag = false;
          Get.off(MainPage());
          return Future(() => true);
        }
    );
  }
}


class PathList extends StatelessWidget{
  PathList(this._pathes);
  final Pathes _pathes;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
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
        Flag = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    var screenwidth = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          child: TextField(
            textInputAction: TextInputAction.next,
            onChanged: (text) {
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

