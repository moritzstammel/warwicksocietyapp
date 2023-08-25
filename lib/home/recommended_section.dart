import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/models/firestore_user.dart';

import '../models/event.dart';
import '../models/society_info.dart';
import 'event_card.dart';

class RecommendedSection extends StatefulWidget {
  final FirestoreUser user;
  const RecommendedSection({Key? key, required this.user}) : super(key: key);


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
        List<Event> eventsNotSignedUp = events.where((event) => !(event.registeredUsers.contains(userRef))).toList();
        print(events);

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





  Event testEvent3(){
    return Event(
      id: "test",
      title: 'Chem Cafe',
      description: 'Description for Event 1',
      location: 'R.021',
      startTime: DateTime.now().add(Duration(days:1,hours: 1)),
      endTime: DateTime.now().add(Duration(days:1,hours: 2)),
      points: 0,
      societyInfo: SocietyInfo(
          name: 'Warwick Student Cinema',
          logoUrl: 'https://www.warwicksu.com/asset/Organisation/4097/Asset%2033.png?thumbnail_width=300&thumbnail_height=300&resize_type=ResizeFitAllFill',
          ref: FirebaseFirestore.instance.doc("/universities/university-of-warwick/societies/Mty9woh57s7t4a9lWWij")
      ),
      images: [],
      registeredUsers: [],
    );
  }
  Event testEvent4(){
    return Event(
      id: "test",
      title: 'CV Workshop',
      description: 'Description for Event 1',
      location: 'S.021',
      startTime: DateTime.now().add(Duration(days:3,hours: 5)),
      endTime: DateTime.now().add(Duration(days:3,hours: 7)),
      points: 200,
      societyInfo: SocietyInfo(
          name: 'Warwick Student Cinema',
          logoUrl: 'https://www.warwicksu.com/asset/Organisation/59901/logo_2.png?thumbnail_width=300&thumbnail_height=300&resize_type=ResizeFitAllFill',
          ref: FirebaseFirestore.instance.doc("/universities/university-of-warwick/societies/Mty9woh57s7t4a9lWWij")
      ),
      images: [],
      registeredUsers: [],
    );
  }
  Event testEvent5(){
    return Event(
      id: "test",
      title: 'Ekimetrics Talk',
      description: 'Description for Event 1',
      location: 'FAB3.14',
      startTime: DateTime.now().add(Duration(days:5,hours: 5)),
      endTime: DateTime.now().add(Duration(days:5,hours: 7)),
      points: 0,
      societyInfo: SocietyInfo(
          name: 'Warwick Student Cinema',
          logoUrl: 'https://www.warwicksu.com/asset/Organisation/59230/icon_gr.png?thumbnail_width=300&thumbnail_height=300&resize_type=ResizeFitAllFill',
          ref: FirebaseFirestore.instance.doc("/universities/university-of-warwick/societies/Mty9woh57s7t4a9lWWij")
      ),
      images: [],
      registeredUsers: [],
    );
  }

}
