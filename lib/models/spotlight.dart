import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:warwicksocietyapp/models/society_info.dart';

class Spotlight {
  final String id;
  final String title;
  final String text;
  final SocietyInfo society;
  final ImageProvider<Object>? image;
  final String imageUrl;
  final List<String> links;
  final DateTime startTime;
  final DateTime endTime;

  Spotlight({required this.id,required this.title, required this.text,required this.society,required this.imageUrl,required this.links,required this.startTime, required this.endTime, this.image});

  factory Spotlight.fromJson(Map<String, dynamic> json,String id) {
    return Spotlight(
      id:id,
      title: json['title'],
      text: json['text'],
      imageUrl: json["image_url"],
      society: SocietyInfo.fromJson(json["society"]),
      links: json["links"].cast<String>(),
      startTime: json["start_time"].toDate(),
      endTime: json["end_time"].toDate()
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'text': text,
      'image_url': imageUrl,
      'society': society.toJson(),
      'links': links,
      'start_time': Timestamp.fromDate(startTime),
      'end_time': Timestamp.fromDate(endTime),
    };
  }


}
