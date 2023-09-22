import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/models/firestore_user.dart';

import '../authentication/FirestoreAuthentication.dart';
import '../models/event.dart';
import '../models/society_info.dart';
import '../widgets/event_card.dart';

class RecommendedSection extends StatefulWidget {
  final FirestoreUser user = FirestoreAuthentication.instance.firestoreUser!;
  RecommendedSection({Key? key}) : super(key: key);


  @override
  State<RecommendedSection> createState() => _RecommendedSectionState();
}

class _RecommendedSectionState extends State<RecommendedSection> {
  late Stream<QuerySnapshot> eventStream;
  late List<String> buildSocieties;

  void setStream(){
    List<SocietyInfo> societies = List<SocietyInfo>.from(widget.user.followedSocieties.values);

    List<DocumentReference> societyRefs = societies.map((society) => society.ref).toList();
    eventStream = (societyRefs.isEmpty) ?
    FirebaseFirestore.instance
        .collection("universities")
        .doc("university-of-warwick")
        .collection("events")
        .where('end_time', isGreaterThan: Timestamp.fromDate(DateTime.now().add(Duration(hours: 2))))
        .limit(5)
        .snapshots()
        :
    FirebaseFirestore.instance
        .collection("universities")
        .doc("university-of-warwick")
        .collection("events")
        .where('society.ref', whereIn: societyRefs)
        .where('end_time', isGreaterThan: Timestamp.fromDate(DateTime.now().add(Duration(hours: 2))))
        .limit(5)
        .snapshots();


    buildSocieties = societies.map((society) => society.ref.id).toList();
  }

  bool societiesWereUpdated() {
    var set1 = Set.from(buildSocieties);
    var set2 = Set.from(widget.user.followedSocieties.values.map((society) => society.ref.id));
    return set1.length != set2.length || !set1.containsAll(set2);
  }

  @override
  void initState() {
    super.initState();
    setStream();
  }

  @override
  Widget build(BuildContext context) {
    if(societiesWereUpdated()) setStream();
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
        List<Event> eventsNotSignedUp = events.where((event) => !((event.registeredUsers.containsKey(userRef.id))&&(event.registeredUsers[userRef.id]!.active))).toList();


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
            ),
          ],

        );
      }
    );
  }



}
