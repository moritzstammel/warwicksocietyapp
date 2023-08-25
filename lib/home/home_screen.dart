import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/home/custom_search_bar.dart';
import 'package:warwicksocietyapp/home/recommended_section.dart';
import 'package:warwicksocietyapp/home/spotlight_builder.dart';
import 'package:warwicksocietyapp/home/top_app_bar.dart';
import 'package:warwicksocietyapp/home/your_events_section.dart';
import '../models/firestore_user.dart';
import '../models/society_info.dart';
import '../models/spotlight.dart';
import '../models/event.dart';
import '../widgets/spotlight_card.dart';
import 'event_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("universities").doc("university-of-warwick").collection("users").where("email",isEqualTo: FirebaseAuth.instance.currentUser!.email!).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }


          final user = FirestoreUser.fromJson(snapshot.data!.docs[0].data() as Map<String, dynamic>,snapshot.data!.docs[0].id);

          print(user.followedSocieties[0].name);
          return Column(
            children: [
              TopAppBar(user: user),
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Add the search bar
                      CustomSearchBar(),
                      SpotlightBuilder(user: user),
                      SizedBox(height: 20), // Space between sections
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            YourEventsSection(user: user,),
                            SizedBox(height: 20),
                            RecommendedSection(user: user,)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      ),
    );
  }

  Event testEvent1(){
    return Event(
      id: "test",
      title: 'Mario Movie Night',
      description: 'Description for Event 1',
      location: 'Copper Rooms',
      startTime: DateTime.now(),
      endTime: DateTime.now().add(Duration(hours: 2)),
      points: 100,
      societyInfo: SocietyInfo(
          name: 'Warwick Student Cinema',
          logoUrl: 'https://www.warwicksu.com/asset/Organisation/4273/su%20pls%20accept.png?thumbnail_width=300&thumbnail_height=300&resize_type=ResizeFitAllFill',
          ref: FirebaseFirestore.instance.doc("/universities/university-of-warwick/societies/Mty9woh57s7t4a9lWWij")
      ),
      images: [],
      registeredUsers: [],
    );
  }
  Event testEvent2(){
    return Event(
      id: "test",
      title: 'Piano Concert',
      description: 'some real music',
      location: 'Panorama Rooms',
      startTime: DateTime.now().add(Duration(days:2,hours: 2)),
      endTime: DateTime.now().add(Duration(days:2,hours: 5)),
      points: 400,
      societyInfo: SocietyInfo(
          name: 'Warwick Piano Society',
          logoUrl: 'https://www.warwicksu.com/asset/Organisation/7883/Newest%20Piano%20Soc%20Logo.png?thumbnail_width=300&thumbnail_height=300&resize_type=ResizeFitAllFill',
          ref: FirebaseFirestore.instance.doc("/universities/university-of-warwick/societies/Mty9woh57s7t4a9lWWij")
      ),
      images: [],
      registeredUsers: [],
    );
  }



  Widget spotlightTestData(){
    return StreamBuilder<Object>(
      stream: null,
      builder: (context, snapshot) {
        return Container(
          width: double.infinity,
          child: SpotlightCard(
            spotlights: [
              Spotlight(
                title: 'Piano\nNewsletter',
                text: 'Spotlight text goes here.',
                image: AssetImage("assets/spotlights_background_image.jpg"),
                society: SocietyInfo(
                  name: "Warwick Piano Society",
                  logoUrl: "test.de",
                  ref:FirebaseFirestore.instance.doc("/universities/university-of-warwick/societies/S3lJHuxEAzhBlIx1EVED")
                ),
              ),
              Spotlight(
                title: 'Warwick Uni\nReport',
                text: 'Spotlight text goes here.',
                society: SocietyInfo(
                    name: "Warwick Piano Society",
                    logoUrl: "test.de",
                    ref:FirebaseFirestore.instance.doc("/universities/university-of-warwick/societies/S3lJHuxEAzhBlIx1EVED")
                ),
                image: AssetImage("assets/dresden.jpg"),
              ),


            ],
            editable: false,
          ),
        );
      }
    );
  }

}

class EventListItem extends StatelessWidget {
  final String title;
  final String description;

  const EventListItem({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
          ),
          SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}


