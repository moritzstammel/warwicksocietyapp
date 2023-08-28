import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/models/chat.dart';
import 'package:warwicksocietyapp/models/firestore_user.dart';

import '../models/message.dart';

class ChatOpenedScreen extends StatefulWidget {
  final String chatId;
  final FirestoreUser user;

  ChatOpenedScreen({required this.chatId, required this.user});

  @override
  _ChatOpenedScreenState createState() => _ChatOpenedScreenState();
}

class _ChatOpenedScreenState extends State<ChatOpenedScreen> {
  final TextEditingController _messageController = TextEditingController();
  late Stream<DocumentSnapshot> chatStream;

  @override
  void initState() {
    super.initState();

    chatStream = FirebaseFirestore.instance.collection("universities")
        .doc("university-of-warwick")
        .collection("chats")
        .doc(widget.chatId)
        .snapshots();
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
        final chat = Chat.fromJson(snapshot.data!.data() as Map<String,dynamic>, widget.chatId);

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
                    bool isUserMessage = message.author.ref.id == widget.user.id;

                    return Row(
                      mainAxisAlignment:
                      isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
                      children: [
                        if (!isUserMessage)
                          CircleAvatar(
                            radius: 18,
                            backgroundImage: NetworkImage(message.author.imageUrl),
                            backgroundColor: Colors.white,
                          ),
                        Container(
                        constraints: BoxConstraints( maxWidth: 250),
                          margin: EdgeInsets.symmetric(
                              vertical: 8, horizontal: isUserMessage ? 16 : 8),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isUserMessage ? Colors.black : Color(0xFFF7F7F7),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            message.content,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              color: isUserMessage ? Colors.white : Colors.black,
                            ),
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
                        if (content.trim() == "") return;

                        Timestamp now = Timestamp.now();

                        final chatRef = FirebaseFirestore.instance.collection('universities')
                            .doc('university-of-warwick')
                            .collection('chats')
                            .doc(chat.id);

                        await chatRef.update(
                            {
                              'messages': FieldValue.arrayUnion([{
                                'author' : {
                                  'name' : widget.user.username,
                                  'image_url' : widget.user.imageUrl,
                                  'ref': FirebaseFirestore.instance.doc("/universities/university-of-warwick/users/${widget.user.id}")},
                                'content' : content,
                                'is_deleted' : false,
                                'created_at' : now
                              }]),
                              'last_time_message_sent' : now
                        });


                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
