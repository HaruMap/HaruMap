import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harumap2/path_list.dart';
import 'package:flutter/services.dart';

class MainPage extends StatefulWidget{
  @override
  _MainPageState createState() => _MainPageState();

}

class _MainPageState extends State<MainPage>{
  String startText = "";
  String stopText = "";
  TextEditingController inputController_start = TextEditingController();
  TextEditingController inputController_stop = TextEditingController();

  @override
  Widget build(BuildContext context){
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: GestureDetector(
          onTap: ()=> FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('$startText'),
                  Padding(
                      child: TextField(
                        textInputAction: TextInputAction.next,
                        onSubmitted: (text) async {
                          inputController_start.text = text;
                          startText = text;
                        },
                        controller: inputController_start,
                        decoration: InputDecoration(
                            labelText: "출발지",
                             border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0))
                            )
                        ),
                      ),
                      padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 5.0),
                  ),
                  Text('$stopText'),
                  Padding(
                      child: TextField(
                        textInputAction: TextInputAction.go,
                        onSubmitted: (text) async {
                          inputController_stop.text = text;
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
                          else{
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
                ],
              ),
            ),
        ),
      ),
    );
  }

  @override
  void dispose(){
    inputController_start.dispose();
    inputController_stop.dispose();
    super.dispose();
  }
}
