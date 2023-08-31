import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../authentication/FirestoreAuthentication.dart';
import '../models/chat.dart';
import '../models/firestore_user.dart';
import '../models/message.dart';

class ChatOpenedScreen extends StatefulWidget {
  final String chatId;
  final FirestoreUser user = FirestoreAuthentication.instance.firestoreUser!;

  ChatOpenedScreen({required this.chatId});

  @override
  _ChatOpenedScreenState createState() => _ChatOpenedScreenState();
}

class _ChatOpenedScreenState extends State<ChatOpenedScreen> {
  final TextEditingController _messageController = TextEditingController();
  late Stream<DocumentSnapshot> chatStream;

  static const Map<int, String> _weekdayShortMap = {
    1: 'Mon',
    2: 'Tue',
    3: 'Wed',
    4: 'Thu',
    5: 'Fri',
    6: 'Sat',
    7: 'Sun',
  };

  @override
  void initState() {
    super.initState();

    chatStream = FirebaseFirestore.instance
        .collection("universities")
        .doc("university-of-warwick")
        .collection("chats")
        .doc(widget.chatId)
        .snapshots();
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  String formatTime(DateTime dateTime) {
    DateTime now = DateTime.now();
    int difference = daysBetween(dateTime, now);


    // Same day but different times
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    //String period = dateTime.hour < 12 ? 'AM' : 'PM';
    String time = '$hour:$minute';

    if (difference==0)  return time;
    if (difference <= 1) return 'yesterday, $time';
    if (difference <= 6) return '${difference} days ago, $time';
    if (difference <= 28) {
      int weeks = (difference / 7).ceil();
      return '$weeks week${weeks > 1 ? 's' : ''} ago, $time';}
    if (difference <= 365) {
      int differenceInMonths = (difference / 12).round();
      return '$differenceInMonths month${differenceInMonths > 1 ? 's' : ''} ago, $time';}

    int differenceInYears = (difference / 365).round();
    return '$differenceInYears year${differenceInYears > 1 ? 's' : ''} ago, $time';


  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: chatStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        }

        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final chat = Chat.fromJson(
            snapshot.data!.data() as Map<String, dynamic>, widget.chatId);

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(chat.societyInfo.logoUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chat.eventInfo.title,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      chat.societyInfo.name,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.info_outline, color: Colors.black),
                onPressed: () {
                  // Implement info action
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: chat.messages.length,
                  itemBuilder: (context, index) {
                    Message message = chat.messages[index];
                    bool isUserMessage =
                        message.author.ref.id == widget.user.id;

                    return Column(
                      crossAxisAlignment: isUserMessage
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [

                        Container(
                          margin : EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            formatTime(message.createdAt),
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              color:
                              isUserMessage ? Colors.black : Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          margin: EdgeInsets.all(8),
                          padding: EdgeInsets.all(8),
                          constraints: BoxConstraints(
                            maxWidth: 250,
                          ),
                          decoration: BoxDecoration(
                            color: isUserMessage
                                ? Colors.black
                                : Color(0xFFF7F7F7),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: isUserMessage
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              if (!isUserMessage)
                                CircleAvatar(
                                  radius: 18,
                                  backgroundImage:
                                  NetworkImage(message.author.imageUrl),
                                  backgroundColor: Colors.white,
                                ),
                              Text(
                                message.content,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  color:
                                  isUserMessage ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: "Type your message...",
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () async {
                        final content = _messageController.text;
                        if (content.trim().isEmpty) return;

                        Timestamp now = Timestamp.now();

                        final chatRef = FirebaseFirestore.instance
                            .collection('universities')
                            .doc('university-of-warwick')
                            .collection('chats')
                            .doc(chat.id);

                        await chatRef.update({
                          'messages': FieldValue.arrayUnion([
                            {
                              'author': {
                                'name': widget.user.username,
                                'image_url': widget.user.imageUrl,
                                'ref': FirebaseFirestore.instance
                                    .doc(
                                    "/universities/university-of-warwick/users/${widget.user.id}")
                              },
                              'content': content,
                              'is_deleted': false,
                              'created_at': now
                            }
                          ]),
                          'time_of_last_message': now
                        });

                        _messageController.clear();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

String formatContent(String content) {
  if (content.length > 60) {
    return '${content.substring(0, 60)}...';
  } else {
    return content;
  }
}
