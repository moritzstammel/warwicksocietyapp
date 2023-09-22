
import 'package:cloud_firestore/cloud_firestore.dart';

import 'author_info.dart';

class SocietyInfo {
  final String name;
  final String logoUrl;
  final DocumentReference ref;
  final DocumentReference? chatRef;
  SocietyInfo({required this.name, required this.logoUrl,required this.ref,this.chatRef});

  factory SocietyInfo.fromJson(Map<String, dynamic> json) => SocietyInfo(name: json["name"], logoUrl: json["logo_url"], ref: json["ref"],chatRef: json["chat_ref"]);

  Map<String, dynamic> toJson() => {"name": name,"logo_url": logoUrl,"ref": ref,"chat_ref" : chatRef};

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SocietyInfo &&
          runtimeType == other.runtimeType &&
          ref == other.ref;

  @override
  int get hashCode => ref.hashCode;

  Author toAuthor() {
    return Author(name: name, imageUrl: logoUrl, ref: ref);
  }
}
