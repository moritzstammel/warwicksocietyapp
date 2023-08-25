
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:warwicksocietyapp/models/society_info.dart';

class Spotlight {
  final String title;
  final String text;
  final SocietyInfo society;
  final ImageProvider<Object> image;

  Spotlight({required this.title, required this.text,required this.society,required this.image});

  factory Spotlight.fromJson(Map<String, dynamic> json) {
    return Spotlight(
      title: json['title'],
      text: json['text'],
      image: Image.network(json["image_url"]).image,
      society: SocietyInfo.fromJson(json["society"]),
    );
  }
}
