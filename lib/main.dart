import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harumap2/startpage.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return GetMaterialApp(
      home: StartPage(),
    );
  }
}



