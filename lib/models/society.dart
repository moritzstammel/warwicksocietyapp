import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:warwicksocietyapp/models/society_info.dart';

class Society {
  final String id;
  final String name;
  final String logoUrl;


  Society({required this.id,required this.name, required this.logoUrl,});

  factory Society.fromJson(Map<String, dynamic> json,id) => Society(name: json["name"], logoUrl: json["logo_url"], id: id);

  Map<String, dynamic> toJson() => {"name": name,"logo_url": logoUrl};

  SocietyInfo toSocietyInfo() => SocietyInfo(name: name, logoUrl: logoUrl, ref: FirebaseFirestore.instance.collection("universities").doc("university-of-warwick").collection("societies").doc(id));

}