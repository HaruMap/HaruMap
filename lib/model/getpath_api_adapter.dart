import 'dart:convert';

import 'model_path.dart';

List<PathDetail> parsePathes(String responseBody){
  final parsed = json.decode(responseBody).cast<String,dynamic>();
  return parsed["pathdetails"].map<PathDetail>((json) => PathDetail.fromJson(json)).toList();
}