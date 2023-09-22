import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:warwicksocietyapp/authentication/SocietyAuthentication.dart';
import '../authentication/FirestoreAuthentication.dart';
import '../chats/chat_card.dart';
import '../models/firestore_user.dart';
import '../models/chat.dart';

class SocietyChatOverviewScreen extends StatefulWidget {
  final FirestoreUser user = FirestoreAuthentication.instance.firestoreUser!;

  SocietyChatOverviewScreen();

  @override
  _SocietyChatOverviewScreenState createState() => _SocietyChatOverviewScreenState();
}

class _SocietyChatOverviewScreenState extends State<SocietyChatOverviewScreen> {
  late Stream<QuerySnapshot> chatStream;
  final PageController _pageController = PageController();
  bool showingSocietyChats = true;
  TextEditingController searchController = TextEditingController();
  String searchString = "";

  @override
  void initState() {
    super.initState();

      chatStream = FirebaseFirestore.instance
        .collection("universities")
        .doc("university-of-warwick")
        .collection("chats")
        .where("society.ref", isEqualTo: SocietyAuthentication.instance.societyInfo!.ref)
        .snapshots();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 35,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            color: Colors.white,
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Color(0xFFF7F7F7),
                borderRadius: BorderRadius.circular(25),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  IconButton(onPressed: () => Navigator.of(context).pop(), icon: Icon(Icons.arrow_back, color: Colors.black)),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        setState(() {
                          searchString = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Search...",
                        hintStyle: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
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

                List<Chat> allChats = snapshot.data!.docs
                    .map((doc) =>
                    Chat.fromJson(doc.data() as Map<String, dynamic>, doc.id))
                    .toList();

                Chat societyChat = allChats.where((chat) => chat.type == "society_chat").first;
                allChats.remove(societyChat);

                allChats.sort((a, b) {
                  if (a.timeOfLastMessage == null) {
                    return 1; // Move items with null timeOfLastMessage to the end
                  } else if (b.timeOfLastMessage == null) {
                    return -1;
                  } else {
                    return b.timeOfLastMessage!
                        .compareTo(a.timeOfLastMessage!);
                  }
                });

                // Filter chats based on the search string
                if (searchString.isNotEmpty) {
                  allChats = allChats.where((chat) =>
                  (chat.isEventChat? chat.eventInfo!.title.toLowerCase().contains(searchString.toLowerCase()) : chat.societyInfo.name.toLowerCase().contains(searchString.toLowerCase() )
                  )).toList();
                }
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8,),
                      Text(
                        'SOCIETY CHAT',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ChatCard(chat: societyChat),
                      SizedBox(height: 8,),
                      Text(
                        'EVENT CHATS',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      for (final chat in allChats)
                      ChatCard(chat: chat),
                      ],
                  ),
                );

                return chatList(allChats);



              },
            ),
          ),
        ],
      ),
    );
  }

  Widget chatList(chats){
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: chats.length,
      itemBuilder: (context, index) {
        var chat = chats[index];
        return ChatCard(
          chat: chat,
        );
      },
    );
  }
}
