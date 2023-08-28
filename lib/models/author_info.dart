
import 'package:cloud_firestore/cloud_firestore.dart';

class Author {
  final String name;
  final String imageUrl;
  final DocumentReference ref;

  Author({required this.name, required this.imageUrl,required this.ref});

  factory Author.fromJson(Map<String, dynamic> json) {

    return Author(name: json["name"], imageUrl: json["image_url"], ref: json["ref"]);
  }


  bool get isSociety {
    return ref.path.contains('societies');
  }
}
