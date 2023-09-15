import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:warwicksocietyapp/authentication/SocietyAuthentication.dart';
import 'package:warwicksocietyapp/event_creation/event_creation_screen.dart';

import '../widgets/event_card.dart';
import '../models/event.dart';
class EventOverviewScreen extends StatefulWidget {

  EventOverviewScreen();

  @override
  _EventOverviewScreenState createState() => _EventOverviewScreenState();
}

class _EventOverviewScreenState extends State<EventOverviewScreen> {
  late Stream<QuerySnapshot> eventStream;

  @override
  void initState() {
    super.initState();

    eventStream = FirebaseFirestore.instance.collection("universities")
        .doc("university-of-warwick")
        .collection("events")
        .where("society.ref", isEqualTo: SocietyAuthentication.instance.societyInfo!.ref)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Events',
          style: TextStyle(color: Colors.black, fontFamily: 'Inter'),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: eventStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<Event> events = snapshot.data!.docs.map((json) => Event.fromJson(json.data() as Map<String, dynamic>, json.id)).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                createEventButton(),

              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Live',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                height: 5,
                width: 30,
                decoration: BoxDecoration(
                  color: Colors.green, // Use your desired color
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 10),
              for (final event in events)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: EventCard(
                    event: event,
                    showRegistered: false,
                  ),
                ),
            ],

          );

        },
      ),
    );
  }

  Widget createEventButton(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          // Trigger the create new spotlight function
          navigateToEventCreation(context);
        },
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
                  ),
                ),
                Icon(
                  Icons.add,
                  size: 30,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void navigateToEventCreation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EventCreationScreen()),
    );
  }
}

