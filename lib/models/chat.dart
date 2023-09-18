import 'package:warwicksocietyapp/models/society_info.dart';
import 'user_info.dart';
import 'event_info.dart';
import 'message.dart';

class Chat {
  final String id;
  final String type; // for now "event_chat" or "society_chat"
  final EventInfo? eventInfo;
  final List<Message> messages;
  final Map<String,UserInfo> users;
  final SocietyInfo societyInfo;
  final DateTime? timeOfLastMessage;


  Chat({required this.id,required this.type, required this.eventInfo,required this.messages,required this.users,required this.societyInfo,
      required this.timeOfLastMessage});

  factory Chat.fromJson(Map<String, dynamic> json, String id) {

    List<Message> messageList = (json["messages"] as List)
        .map((messageJson) => Message.fromJson(messageJson))
        .toList();


    Map<String,UserInfo> userList =  Map<String, dynamic>.from(json["users"]).map((key, value) => MapEntry(key,UserInfo.fromJson(value)));

    return Chat(
        id: id,
        eventInfo: EventInfo.fromJson(json["event"]),
        type: json["type"],
        messages: messageList,
        users: userList,
        societyInfo: SocietyInfo.fromJson(json["society"]),
        timeOfLastMessage: (json["time_of_last_message"] != null) ? json["time_of_last_message"].toDate() : null);
  }

  bool get isSocietyChat {
    return type == "society_chat";
  }
  bool get isEventChat {
    return type == "event_chat";
  }
}
