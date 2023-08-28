import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/firestore_user.dart';
import 'chat_card.dart';
import '../models/chat.dart'; // Import the Chat class

class ChatOverviewScreen extends StatefulWidget {
  final FirestoreUser user;

  ChatOverviewScreen({required this.user});

  @override
  _ChatOverviewScreenState createState() => _ChatOverviewScreenState();
}

class _ChatOverviewScreenState extends State<ChatOverviewScreen> {
  late Stream<QuerySnapshot> chatStream;

  @override
  void initState() {
    super.initState();

    chatStream = FirebaseFirestore.instance.collection("universities")
        .doc("university-of-warwick")
        .collection("chats")
        .where("user_ids.test",isEqualTo: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "Chats",
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
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

          List<QueryDocumentSnapshot> chatDocs = snapshot.data!.docs;

          return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: chatDocs.length,
            itemBuilder: (context, index) {
              var chatData = chatDocs[index].data() as Map<String, dynamic>;
              var id = chatDocs[index].id;
              // Create a Chat instance using factory method
              var chat = Chat.fromJson(chatData,id);

              // Create a ChatCard widget with chat data
              return ChatCard(
                user: widget.user,
                chat: chat, // Pass the chat instance to ChatCard
              );
            },
          );
        },
      ),
    );
  }
}
