
import 'package:cloud_firestore/cloud_firestore.dart';
class Message {
  final String content;
  final DateTime createdAt;
  final bool isDeleted;
  final DocumentReference author;

  Message({required this.content, required this.createdAt,required this.isDeleted,required this.author});

  factory Message.fromJson(Map<String, dynamic> json) {

    return Message(
        content: json["content"],
        createdAt: json["created_at"].toDate(),
        isDeleted: json["is_deleted"],
        author: json["author"]);
  }
  bool get authorIsSociety {
    return author.path.contains('societies');
  }
  bool get authorIsUser {
    return author.path.contains('users');
  }

}
