import 'package:warwicksocietyapp/models/society_info.dart';
import 'user_info.dart';
import 'event_info.dart';
import 'message.dart';

class Chat {
  final String id;
  final EventInfo eventInfo;
  final List<Message> messages;
  final List<UserInfo> users;
  final SocietyInfo societyInfo;
  final DateTime? timeOflastMessage;


  Chat({required this.id, required this.eventInfo,required this.messages,required this.users,required this.societyInfo,
      required this.timeOflastMessage});

  factory Chat.fromJson(Map<String, dynamic> json, String id) {

    List<Message> messageList = (json["messages"] as List)
        .map((messageJson) => Message.fromJson(messageJson))
        .toList();


    List<UserInfo> userList = (json["users"] as List)
        .map((userJson) => UserInfo.fromJson(userJson))
        .toList();


    return Chat(
        id: id,
        eventInfo: EventInfo.fromJson(json["event"]),
        messages: messageList,
        users: userList,
        societyInfo: SocietyInfo.fromJson(json["society"]),
        timeOflastMessage: (json["time_of_last_message"] != null) ? json["time_of_last_message"].toDate() : null);
  }


}
