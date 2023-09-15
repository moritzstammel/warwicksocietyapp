import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/chat.dart';

class ChatDetailsScreen extends StatefulWidget {
  final Chat chat;

  const ChatDetailsScreen({Key? key,required this.chat}) : super(key: key);

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  @override
  Widget build(BuildContext context) {
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
      body: Container(
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

            Text(widget.chat.eventInfo.title,
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
            Container(
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
            SizedBox(height: 52,),
            Text("${widget.chat.users.length} participants", style: TextStyle(
              fontFamily: "Inter",
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black

            ),)
          ],
        ),
      ),
    );
  }
}
