import 'dart:convert';

import 'model_path.dart';

List<PathDetail> parsePathes(List<dynamic> path){
  // final parsed = json.decode(responseBody).cast<String,dynamic>();
  return path.map<PathDetail>((json) => PathDetail.fromJson(json)).toList();
}

List<WayDetail> parsewayPathes(String responseBody){
  final parsed = json.decode(responseBody).cast<String,dynamic>();
  print(parsed);
  return parsed["pathdetails"][0].map<WayDetail>((json) => WayDetail.fromJson(json)).toList();
}