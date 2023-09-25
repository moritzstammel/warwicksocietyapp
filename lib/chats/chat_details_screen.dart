import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/models/event.dart';
import 'package:warwicksocietyapp/widgets/user_card.dart';
import '../home/event_details_screen.dart';
import '../models/chat.dart';
import '../models/user_info.dart';

class ChatDetailsScreen extends StatefulWidget {
  final Chat chat;

  const ChatDetailsScreen({Key? key,required this.chat}) : super(key: key);

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}


class _ChatDetailsScreenState extends State<ChatDetailsScreen> {



  void navigateToEventsDetails(Event event) {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => EventDetailsScreen(event: event)));
  }
  @override
  Widget build(BuildContext context) {
    List<UserInfo> activeUsers = widget.chat.users.values.where((user) => user.active).toList();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: NetworkImage(widget.chat.societyInfo.logoUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              Text(widget.chat.isEventChat ? widget.chat.eventInfo!.title : widget.chat.societyInfo.name,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: Colors.black,
                fontFamily: "Inter"
              ),),
              SizedBox(height: 4,),
              Text(widget.chat.societyInfo.name,
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Color(0xFF777777),
                    fontFamily: "Inter"
                ),),
              SizedBox(height: 20,),
              if(widget.chat.isEventChat)
              GestureDetector(
                onTap: () async{

                  DocumentReference eventsRef = FirebaseFirestore.instance.doc(
                      "universities/university-of-warwick/events/${widget.chat.id}");
                  final eventData = await eventsRef.get();
                  Event event = Event.fromJson(
                      eventData.data() as Map<String, dynamic>, eventData.id);
                  navigateToEventsDetails(event);
                },
                child: Container(
                  width: 105,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(
                    child: Text(
                      "Event page",
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 52,),
              Text("${activeUsers.length} ${(widget.chat.isEventChat) ? "participants" : "members"}", style: TextStyle(
                fontFamily: "Inter",
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black

              ),),
              SizedBox(height: 8,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  for (final user in activeUsers)
                    Column(
                      children: [
                        UserCard(userInfo: user),
                        Divider()
                      ],
                    ),
                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}
