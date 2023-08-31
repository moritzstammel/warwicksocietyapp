import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event.dart';
import '../models/firestore_user.dart';

class EventDetailsScreen extends StatefulWidget {
  final Event event;
  final FirestoreUser user;

  EventDetailsScreen({required this.event, required this.user});

  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  bool userIsRegistered = false;

  @override
  void initState() {
    super.initState();
    checkRegistrationStatus();
  }

  void checkRegistrationStatus() {
    setState(() {
      userIsRegistered =
          widget.event.registeredUsers.containsKey(widget.user.id) &&  widget.event.registeredUsers[widget.user.id]==true;
    });
  }

  void toggleRegistration() {
    setState(() {
      userIsRegistered = !userIsRegistered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
            widget.event.title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
          ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {

                DocumentReference eventRef = FirebaseFirestore.instance.doc("universities/university-of-warwick/events/${widget.event.id}");
                DocumentReference chatRef = FirebaseFirestore.instance.doc("universities/university-of-warwick/chats/${widget.event.id}");

                Map<String,dynamic> updatedEventUsers = {
                  'registered_users.${widget.user.id}': !userIsRegistered
                };
                Map<String,dynamic> updatedChatUsers = {
                  'user_ids.${widget.user.id}': !userIsRegistered
                };

                final batch = FirebaseFirestore.instance.batch();
                batch.update(eventRef, updatedEventUsers);
                batch.update(chatRef, updatedChatUsers);
                await batch.commit();


                toggleRegistration();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                minimumSize: Size(350, 50),
              ),
              child: Text(
                userIsRegistered ? 'Sign Out' : 'Sign Up',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Inter',
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }
}
