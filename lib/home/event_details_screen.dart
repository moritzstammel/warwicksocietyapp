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
          widget.event.registeredUsers.map((e) => e.id).contains(widget.user.id);
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
              onPressed: () {
                if (userIsRegistered) {
                  // Perform sign out action
                  FirebaseFirestore.instance
                      .doc("universities/university-of-warwick/events/${widget.event.id}")
                      .update({
                    'registered_users': FieldValue.arrayRemove([
                      FirebaseFirestore.instance
                          .doc("universities/university-of-warwick/users/${widget.user.id}")
                    ]),
                  });
                } else {
                  // Perform sign up action
                  FirebaseFirestore.instance
                      .doc("universities/university-of-warwick/events/${widget.event.id}")
                      .update({
                    'registered_users': FieldValue.arrayUnion([
                      FirebaseFirestore.instance
                          .doc("universities/university-of-warwick/users/${widget.user.id}")
                    ]),
                  });
                }
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
