import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:warwicksocietyapp/home/event_details_screen.dart';
import 'package:warwicksocietyapp/models/event.dart';
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

class _ChatOpenedScreenState extends State<ChatOpenedScreen> with WidgetsBindingObserver {
  final ScrollController _scrollController = new ScrollController();
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
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
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();


  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    chatStream = FirebaseFirestore.instance
        .collection("universities")
        .doc("university-of-warwick")
        .collection("chats")
        .doc(widget.chatId)
        .snapshots();

  }
  @override
  void didChangeMetrics() {
    final mediaQuery = MediaQuery.of(context);
    final isKeyboardOpening = mediaQuery.viewInsets.bottom > 0 && mediaQuery.viewInsets.bottom != mediaQuery.padding.bottom;


    if (isKeyboardOpening) {

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    }
  }


  void navigateToEventsDetails(Event event) {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => EventDetailsScreen(event: event)));
  }


  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to
        .difference(from)
        .inHours / 24).round();
  }

  String formatTime(DateTime dateTime) {

    DateTime now = DateTime.now();
    int difference = daysBetween(dateTime, now);


    // Same day but different times
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    //String period = dateTime.hour < 12 ? 'AM' : 'PM';
    String time = '$hour:$minute';
    return time;
    if (difference == 0) return time;
    if (difference <= 1) return 'yesterday, $time';
    if (difference <= 6) return '${difference} days ago, $time';
    if (difference <= 28) {
      int weeks = (difference / 7).ceil();
      return '$weeks week${weeks > 1 ? 's' : ''} ago, $time';
    }
    if (difference <= 365) {
      int differenceInMonths = (difference / 12).round();
      return '$differenceInMonths month${differenceInMonths > 1
          ? 's'
          : ''} ago, $time';
    }

    int differenceInYears = (difference / 365).round();
    return '$differenceInYears year${differenceInYears > 1
        ? 's'
        : ''} ago, $time';
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
                onPressed: () async {
                  DocumentReference eventsRef = FirebaseFirestore.instance.doc(
                      "universities/university-of-warwick/events/${chat.id}");
                  final eventData = await eventsRef.get();
                  Event event = Event.fromJson(
                      eventData.data() as Map<String, dynamic>, eventData.id);
                  navigateToEventsDetails(event);
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: chat.messages.length,
                    itemBuilder: (context, index) {
                      Message message = chat.messages[index];
                      bool isUserMessage = message.author.ref.id ==
                          widget.user.id;

                      return Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: Row(

                            mainAxisAlignment: isUserMessage ? MainAxisAlignment
                                .end : MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (!isUserMessage)
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          chat.societyInfo.logoUrl),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              SizedBox(width: 8,),
                              Column(
                                crossAxisAlignment: isUserMessage
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: isUserMessage
                                          ? Colors.black
                                          : Color(0xFFF7F7F7),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    constraints: BoxConstraints(
                                      maxWidth: 250,
                                    ),
                                    child: Text(
                                      message.content,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 16,
                                        color: isUserMessage
                                            ? Colors.white
                                            : Colors.black,
                                      ),

                                    ),
                                  ),
                                  SizedBox(height: 4,),
                                  Row(
                                    children: [
                                      if (!isUserMessage)
                                        Text(
                                          message.author.name, style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black
                                        ),),
                                      if (!isUserMessage) SizedBox(width: 2,),
                                      Text("sent at ${formatTime(
                                          message.createdAt)}",
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Color(0xFF888888)
                                        ),)

                                    ],
                                  )
                                ],
                              ),
                            ]
                        ),
                      );
                    },
                  )

              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Container(

                        height: 56,
                        width: 280,
                        decoration: BoxDecoration(
                          color: Color(0xFFF7F7F7),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  focusNode: _focusNode,
                                  controller: _messageController,
                                  decoration: InputDecoration(
                                    hintText: "Type your message here...",
                                    hintStyle: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      color: Color(0xFF777777),
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    SizedBox(width: 16,),
                    GestureDetector(
                      onTap: () => sendMessage(chat),
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(

                            Icons.send,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )

            ],
          ),
        );
      },
    );
  }


  void sendMessage(Chat chat) async {
    final content = _messageController.text;
    if (content
        .trim()
        .isEmpty) return;

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

  }

  String formatContent(String content) {
    if (content.length > 60) {
      return '${content.substring(0, 60)}...';
    } else {
      return content;
    }
  }
}
