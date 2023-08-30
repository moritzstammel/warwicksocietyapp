
import 'package:cloud_firestore/cloud_firestore.dart';

class SocietyInfo {
  final String name;
  final String logoUrl;
  final DocumentReference ref;

  SocietyInfo({required this.name, required this.logoUrl,required this.ref});

  factory SocietyInfo.fromJson(Map<String, dynamic> json) => SocietyInfo(name: json["name"], logoUrl: json["logo_url"], ref: json["ref"]);

  Map<String, dynamic> toJson() => {"name": name,"logo_url": logoUrl,"ref": ref};

}
