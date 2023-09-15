import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/models/firestore_user.dart';

import '../authentication/FirestoreAuthentication.dart';
import '../models/event.dart';
import '../models/society_info.dart';
import '../widgets/event_card.dart';

class YourEventsSection extends StatefulWidget {
  final FirestoreUser user = FirestoreAuthentication.instance.firestoreUser!;
  YourEventsSection({Key? key}) : super(key: key);


  @override
  State<YourEventsSection> createState() => _YourEventsSectionState();
}

class _YourEventsSectionState extends State<YourEventsSection> {
  late Stream<QuerySnapshot> eventStream;


  @override
  void initState() {
    super.initState();
    DocumentReference userRef = FirebaseFirestore.instance.doc("universities/university-of-warwick/users/${widget.user.id}");
    eventStream = FirebaseFirestore.instance
        .collection("universities")
        .doc("university-of-warwick")
        .collection("events")
        .where('registered_users.${userRef.id}',isEqualTo: true)
        .snapshots();


  }

  @override
  Widget build(BuildContext context) {

    List<DocumentReference> societyRefs = widget.user.followedSocieties.map((society) => society.ref).toList();

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


          final events = snapshot.data!.docs.map((json) => Event.fromJson(json.data() as Map<String,dynamic>,json.id)).toList();

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
