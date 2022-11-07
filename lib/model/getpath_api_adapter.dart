import 'dart:convert';

import 'model_path.dart';

List<PathDetail> parsePathes(String responseBody){
  final parsed = json.decode(responseBody).cast<Map<String,dynamic>>();
  return parsed.map<PathDetail>((json) => PathDetail.fromJson(json)).toList();
}