
import 'package:flutter/cupertino.dart';

class PathDetail {
  int totaltime;
  List<dynamic> description;
  List<dynamic> totaldescription;
  int score;

  PathDetail({
    required this.totaltime, required this.score, required this.description, required this.totaldescription});

  PathDetail.fromMap(Map<String, dynamic> map)
      : totaltime = map['totaltime'],
        score = map["score"],
        description = map["description"],
        totaldescription = map["totaldescription"];

  PathDetail.fromJson(Map<String, dynamic> json)
      : totaltime = json["totaltime"],
        score = json["score"],
        description = json["description"],
        totaldescription = json["totaldescription"];

}
