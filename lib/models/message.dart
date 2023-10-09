
import 'package:cloud_firestore/cloud_firestore.dart';
class Message {
  final String content;
  final DateTime createdAt;
  final DocumentReference author;
  bool isDeleted;


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
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Message &&
              runtimeType == other.runtimeType &&
              createdAt == other.createdAt &&
              author == other.author &&
              content == other.content;

  void delete() {
    isDeleted = true;
  }
  Map<String, dynamic> toJson() {
    return {
      "content": content,
      "created_at": createdAt,
      "is_deleted": isDeleted,
      "author": author,
    };
  }

  @override
  String toString() {
    return isDeleted.toString();
  }
}
