
import 'author_info.dart';

class Message {
  final String content;
  final DateTime createdAt;
  final bool isDeleted;
  final Author author;

  Message({required this.content, required this.createdAt,required this.isDeleted,required this.author});

  factory Message.fromJson(Map<String, dynamic> json) {

    return Message(
        content: json["content"],
        createdAt: json["created_at"].toDate(),
        isDeleted: json["is_deleted"],
        author: Author.fromJson(json["author"]));
  }


}
