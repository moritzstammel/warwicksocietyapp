
import 'package:cloud_firestore/cloud_firestore.dart';

class Spotlight {
  final String title;
  final String text;
  final DocumentReference societyRef;
  final String imageUrl;

  Spotlight({required this.title, required this.text,required this.societyRef,required this.imageUrl});

  factory Spotlight.fromJson(Map<String, dynamic> json) {
    return Spotlight(
      title: json['title'],
      text: json['text'],
      societyRef: json['society_ref'],
      imageUrl: json["image_url"],
    );
  }
}
