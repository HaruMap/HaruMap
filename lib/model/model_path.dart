
import 'package:flutter/cupertino.dart';

class PathDetail {
  double totaltime;
  List<dynamic> description;
  List<dynamic> totaldescription;
  List<dynamic> coor;

  PathDetail({
    required this.totaltime, required this.description, required this.totaldescription,required this.coor});

  PathDetail.fromMap(Map<String, dynamic> map)
      : totaltime = map['totaltime'],
        description = map["description"],
        totaldescription = map["totaldescription"],
        coor = map["coor"];

  PathDetail.fromJson(Map<String, dynamic> json)
      : totaltime = json["totaltime"],
        description = json["description"],
        totaldescription = json["totaldescription"],
        coor = json["coor"];

}

class WayDetail {
  List<dynamic> tot;
  List<dynamic> sub;
  List<dynamic> bus;
  List<dynamic> subbus;

  WayDetail({
    required this.tot, required this.sub, required this.bus, required this.subbus});

  WayDetail.fromMap(Map<String, dynamic> map)
      : tot = map["tot"],
        sub = map["sub"],
        bus = map["bus"],
        subbus = map["subbus"];

  WayDetail.fromJson(Map<String, dynamic> json)
      : tot = json["tot"],
        sub = json["sub"],
        bus = json["bus"],
        subbus = json["subbus"];

}