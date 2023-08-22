
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Spotlight {
  final String title;
  final String text;
  final DocumentReference societyRef;
  final ImageProvider<Object> image;

  Spotlight({required this.title, required this.text,required this.societyRef,required this.image});

  factory Spotlight.fromJson(Map<String, dynamic> json) {
    return Spotlight(
      title: json['title'],
      text: json['text'],
      societyRef: json['society_ref'],
      image: Image.network(json["image_url"]).image,
    );
  }
}
