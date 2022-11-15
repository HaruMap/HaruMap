
import 'package:flutter/cupertino.dart';

class PathDetail {
  int totaltime;
  List<dynamic> description;
  List<dynamic> totaldescription;
  List<dynamic> coordinate;
  int score;

  PathDetail({
    required this.totaltime, required this.score, required this.description, required this.totaldescription,required this.coordinate});

  PathDetail.fromMap(Map<String, dynamic> map)
      : totaltime = map['totaltime'],
        score = map["score"],
        description = map["description"],
        totaldescription = map["totaldescription"],
        coordinate = map["coordinate"];

  PathDetail.fromJson(Map<String, dynamic> json)
      : totaltime = json["totaltime"],
        score = json["score"],
        description = json["description"],
        totaldescription = json["totaldescription"],
        coordinate = json["coordinate"];

}
