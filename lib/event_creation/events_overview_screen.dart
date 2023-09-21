import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:warwicksocietyapp/authentication/SocietyAuthentication.dart';
import 'package:warwicksocietyapp/event_creation/event_creation_screen.dart';

import '../admin/society_app_bar.dart';
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
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,

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
          List<Event> upcomingEvents = events.where((event) => DateTime.now().isBefore(event.endTime.add(Duration(hours: 2)))).toList();
          List<Event> pastEvents = events.where((event) => DateTime.now().isAfter(event.endTime.add(Duration(hours: 2)))).toList();


          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  SocietyAppBar(),
                  SizedBox(height: 18,),
                  createEventButton(),
                  if (upcomingEvents.isNotEmpty)
                  upcomingEventsSection(upcomingEvents),
                  if(pastEvents.isNotEmpty)
                  pastEventsSection(pastEvents)


              ],

            ),
          );

        },
      ),
    );
  }
  Widget pastEventsSection(List<Event> pastEvents){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Past events',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 10),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          height: 5,
          width: 30,
          decoration: BoxDecoration(
            color: Color(0xFFDD0000), // Use your desired color
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        SizedBox(height: 10),
        for (final event in pastEvents)
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: EventCard(
              event: event,
              showRegistered: false,
            ),
          ),
      ],
    );
  }

  Widget upcomingEventsSection(List<Event> upcomingEvents){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Upcoming events',
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
        for (final event in upcomingEvents)
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: EventCard(
              event: event,
              showRegistered: false,
              isEditable: true,
            ),
          ),
      ],
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

