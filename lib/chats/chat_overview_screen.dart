import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../authentication/FirestoreAuthentication.dart';
import '../models/firestore_user.dart';
import 'chat_card.dart';
import '../models/chat.dart'; // Import the Chat class

class ChatOverviewScreen extends StatefulWidget {
  final FirestoreUser user = FirestoreAuthentication.instance.firestoreUser!;

  ChatOverviewScreen();

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
        .where("user_ids.${widget.user.id}",isEqualTo: true)

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
            print(snapshot.error);
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<Chat> chats = snapshot.data!.docs.map((doc) => Chat.fromJson(doc.data() as Map<String,dynamic>,doc.id)).toList();

          chats.sort((a, b) {
            if (a.timeOfLastMessage == null) {
              return 1; // Move items with null timeOfLastMessage to the end
            } else if (b.timeOfLastMessage == null) {
              return -1;
            } else {
              return b.timeOfLastMessage!.compareTo(a.timeOfLastMessage!);
            }
          });

          return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: chats.length,
            itemBuilder: (context, index) {
              var chat = chats[index];

              // Create a ChatCard widget with chat data
              return ChatCard(
                chat: chat, // Pass the chat instance to ChatCard
              );
            },
          );
        },
      ),
    );
  }
}
