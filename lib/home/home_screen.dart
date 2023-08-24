import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/home/custom_search_bar.dart';
import 'package:warwicksocietyapp/home/spotlight_builder.dart';
import 'package:warwicksocietyapp/home/top_app_bar.dart';

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
      body: Column(
        children: [
          TopAppBar(),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Add the search bar
                  CustomSearchBar(),
                  spotlightTestData(),
                  SizedBox(height: 20), // Space between sections
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'YOUR EVENTS',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        EventCard(
                          event: testEvent1(),
                        ),
                        EventCard(
                          event: testEvent2(),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'RECOMMENDED FOR YOU',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        EventCard(
                          event: testEvent3(),
                          showRegistered: false,
                        ),
                        EventCard(
                          event: testEvent4(),
                          showRegistered: false,
                        ),
                        EventCard(
                          event: testEvent5(),
                          showRegistered: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Event testEvent1(){
    return Event(
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
  Event testEvent3(){
    return Event(
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



  Widget spotlightTestData(){
    return Container(
      width: double.infinity,
      child: SpotlightCard(
        spotlights: [
          Spotlight(
            title: 'Piano\nNewsletter',
            text: 'Spotlight text goes here.',
            societyRef: FirebaseFirestore.instance.doc("/universities/university-of-warwick/societies/S3lJHuxEAzhBlIx1EVED"),
            image: AssetImage("assets/spotlights_background_image.jpg"),
          ),
          Spotlight(
            title: 'Warwick Uni\nReport',
            text: 'Spotlight text goes here.',
            societyRef: FirebaseFirestore.instance.doc("/universities/university-of-warwick/societies/S3lJHuxEAzhBlIx1EVED"),
            image: AssetImage("assets/dresden.jpg"),
          ),


        ],
        editable: false,
      ),
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


