import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/models/firestore_user.dart';
import '../authentication/FirestoreAuthentication.dart';
import '../models/event.dart';
import '../widgets/event_card.dart';

class YourEventsSection extends StatefulWidget {
  final FirestoreUser user = FirestoreAuthentication.instance.firestoreUser!;
  YourEventsSection({Key? key}) : super(key: key);


  @override
  State<YourEventsSection> createState() => _YourEventsSectionState();
}

class _YourEventsSectionState extends State<YourEventsSection> {
  late Stream<QuerySnapshot> eventStream;
  late List<String> buildSocieties;



  @override
  void initState() {
    super.initState();
    eventStream = FirebaseFirestore.instance
        .collection("universities")
        .doc("university-of-warwick")
        .collection("events")
        .where('registered_users.${widget.user.id}.active',isEqualTo: true)
        .snapshots();


  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
        stream: eventStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }


          List<Event> events = snapshot.data!.docs.map((json) => Event.fromJson(json.data() as Map<String,dynamic>,json.id)).toList();
          events = events.where((event) => event.endTime.isAfter(DateTime.now().add(Duration(hours: 2)))).toList();
          events.sort();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(events.isNotEmpty)
              Text(
                'YOUR EVENTS',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                ),
              ),
              if(events.isNotEmpty)
              SizedBox(height: 10),
              for (final event in events)
                EventCard(
                  event: event,
                  showRegistered: true,
                ),
            ],

          );
        }
    );
  }


}
