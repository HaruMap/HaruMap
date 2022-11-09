


class AddrLoc {
  String place_name;
  String road_address_name;
  String address_name;
  String phone;
  String lat;
  String lng;

  AddrLoc({
    required this.place_name,
    required this.road_address_name,
    required this.address_name,
    required this.phone,
    required this.lat,
    required this.lng
  });

  AddrLoc.fromMap(Map<String, dynamic> map)
      : place_name = map['place_name'],
        road_address_name = map["road_address_name"],
        address_name = map["address_name"],
        phone = map["phone"],
        lat = map["lat"],
        lng = map["lng"];

  AddrLoc.fromJson(Map<String, dynamic> json)
      : place_name = json["place_name"],
        road_address_name = json["road_address_name"],
        address_name = json["address_name"],
        phone = json["phone"],
        lat = json["y"],
        lng = json["x"];

}



