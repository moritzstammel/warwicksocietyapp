import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:warwicksocietyapp/error_screen.dart';
import '../authentication/FirestoreAuthentication.dart';
import '../models/firestore_user.dart';
import 'chat_card.dart';
import '../models/chat.dart';

class ChatOverviewScreen extends StatefulWidget {
  final FirestoreUser user = FirestoreAuthentication.instance.firestoreUser!;

  ChatOverviewScreen();

  @override
  _ChatOverviewScreenState createState() => _ChatOverviewScreenState();
}

class _ChatOverviewScreenState extends State<ChatOverviewScreen> {
  late Stream<QuerySnapshot> eventChatStream;
  final PageController _pageController = PageController();
  bool showingSocietyChats = true;
  TextEditingController searchController = TextEditingController();
  String searchString = "";

  @override
  void initState() {
    super.initState();

    eventChatStream = FirebaseFirestore.instance
        .collection("universities")
        .doc("university-of-warwick")
        .collection("chats")
        .where("users.${widget.user.id}.active", isEqualTo: true)
        .snapshots();


  }

  void toggleSelection() {
    setState(() {
      showingSocietyChats = !showingSocietyChats;
    });

    _pageController.animateToPage(
      showingSocietyChats ? 0 : 1,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );


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
          chatSelectionBar(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: eventChatStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  ErrorScreen();
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

                List<Chat> societyChats = List.from(allChats.where((chat) => chat.type == "society_chat"));
                List<Chat> eventChats = List.from(allChats.where((chat) => chat.type == "event_chat"));

              return PageView(
                  controller: _pageController,
                  onPageChanged: (index){
                    setState(() {
                      showingSocietyChats = index.isEven;
                    });
                  },

                  scrollDirection: Axis.horizontal,
                  children: [
                    chatList(societyChats),
                    chatList(eventChats)
                  ]
              );


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

  Widget chatSelectionBar() {
    int durationInMilliseconds = 170;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          width: 303,
          height: 39,

          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(100)),
            color: Color(0xFFF7F7F7),
          ),
          child: Stack(
              children: [
                AnimatedPositioned(

                  duration: Duration(milliseconds: durationInMilliseconds),
                  curve: Curves.easeOut,
                  left: !showingSocietyChats ? 151.5 : 1,
                  top: 2,

                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      color: Colors.black,
                    ),
                    width: 149.5,
                    height: 35,

                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => toggleSelection(),
                      child: AnimatedContainer(

                        duration: Duration(milliseconds: durationInMilliseconds),
                        height: 39,
                        width: 151.5,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(

                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                        child: Center(
                          child: Text(
                            'Society Chats',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              color: showingSocietyChats ? Colors.white : const Color(0xFF888888),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => toggleSelection(),
                      child: AnimatedContainer(
                        height: 39,
                        width: 151.5,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(

                          borderRadius: BorderRadius.all(Radius.circular(100)),

                        ),
                        duration: Duration(milliseconds: durationInMilliseconds),
                        child: Center(
                          child: Text(
                            'Event Chats',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              color: !showingSocietyChats ? Colors.white : const Color(0xFF888888),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

              ]),

        ),
      ],
    );
  }
}
