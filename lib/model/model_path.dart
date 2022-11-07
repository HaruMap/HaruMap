
class PathDetail {
  int totaltime;
  int totalwalk;
  List<String> description;

  PathDetail({
    required this.totaltime, required this.totalwalk, required this.description});

  PathDetail.fromMap(Map<String, dynamic> map)
      : totaltime = map['totaltime'],
        totalwalk = map["totalwalk"],
        description = map["description"];

  PathDetail.fromJson(Map<String, dynamic> json)
      : totaltime = json["totaltime"],
        totalwalk = json["totalwalk"],
        description = json["description"];

}