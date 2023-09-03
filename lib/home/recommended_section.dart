import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/models/firestore_user.dart';

import '../authentication/FirestoreAuthentication.dart';
import '../models/event.dart';
import '../models/society_info.dart';
import 'event_card.dart';

class RecommendedSection extends StatefulWidget {
  final FirestoreUser user = FirestoreAuthentication.instance.firestoreUser!;
  RecommendedSection({Key? key}) : super(key: key);


  @override
  State<RecommendedSection> createState() => _RecommendedSectionState();
}

class _RecommendedSectionState extends State<RecommendedSection> {
  late Stream<QuerySnapshot> eventStream;


  @override
  void initState() {
    super.initState();

    List<DocumentReference> societyRefs = widget.user.followedSocieties.map((society) => society.ref).toList();
    eventStream = FirebaseFirestore.instance.collection("universities")
        .doc("university-of-warwick")
        .collection("events")
        .where("society.ref", whereIn: societyRefs)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {

    DocumentReference userRef = FirebaseFirestore.instance.doc("universities/university-of-warwick/users/${widget.user.id}");

    return StreamBuilder<QuerySnapshot>(
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


        List<Event> events = snapshot.data!.docs.map((json) => Event.fromJson(json.data() as Map<String,dynamic>,json.id)).toList();
        List<Event> eventsNotSignedUp = events.where((event) => !((event.registeredUsers.containsKey(userRef.id))&&(event.registeredUsers[userRef.id]==true))).toList();


        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(eventsNotSignedUp.isNotEmpty)
              Text(
              'RECOMMENDED FOR YOU',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
              ),
            ),
            if(eventsNotSignedUp.isNotEmpty)
            SizedBox(height: 10),
            for (final event in eventsNotSignedUp)
            EventCard(
              event: event,
              showRegistered: false,
              user: widget.user,
            ),
          ],

        );
      }
    );
  }



}
