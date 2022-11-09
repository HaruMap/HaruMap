import 'dart:convert';

import 'package:harumap2/model/model_addr.dart';


List<AddrLoc> parseAddrLoc(String responseBody){
  final parsed = json.decode(responseBody).cast<String,dynamic>();
  return parsed["documents"].map<AddrLoc>((json) => AddrLoc.fromJson(json)).toList();
}