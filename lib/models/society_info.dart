
import 'package:cloud_firestore/cloud_firestore.dart';

class SocietyInfo {
  final String name;
  final String logoUrl;
  final DocumentReference ref;

  SocietyInfo({required this.name, required this.logoUrl,required this.ref});

  factory SocietyInfo.fromJson(Map<String, dynamic> json) {
    return SocietyInfo(name: json["name"], logoUrl: json["logo_url"], ref: json["ref"]);
  }

}
