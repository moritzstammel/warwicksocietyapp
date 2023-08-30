import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/models/firestore_user.dart';

import '../models/event.dart';
import '../models/society_info.dart';
import 'event_card.dart';

class YourEventsSection extends StatefulWidget {
  final FirestoreUser user;
  const YourEventsSection({Key? key, required this.user}) : super(key: key);


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
        .where('registered_users',arrayContains:userRef)
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
