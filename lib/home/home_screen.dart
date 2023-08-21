import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/home/spotlight_builder.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SpotlightBox(),
          Expanded(
            child: ListView(
              children: [
                EventListItem('Event 1', '10:00 AM', 'August 10'),
                EventListItem('Event 2', '2:00 PM', 'August 15'),
                EventListItem('Event 3', '6:30 PM', 'August 20'),
                // Add more EventListItems here
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EventListItem extends StatelessWidget {
  final String eventName;
  final String eventTime;
  final String eventDate;

  EventListItem(this.eventName, this.eventTime, this.eventDate);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(eventName),
      subtitle: Text('$eventTime • $eventDate'),
      // Add action for the event list item here
    );
  }
}