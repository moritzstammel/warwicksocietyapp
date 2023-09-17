import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/authentication/FirestoreAuthentication.dart';
import 'package:warwicksocietyapp/home/custom_search_bar.dart';
import 'package:warwicksocietyapp/home/recommended_section.dart';
import 'package:warwicksocietyapp/home/spotlight_builder.dart';
import 'package:warwicksocietyapp/home/top_app_bar.dart';
import 'package:warwicksocietyapp/home/your_events_section.dart';
import '../models/firestore_user.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
    late Stream<QuerySnapshot> userStream;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:
          Column(
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
                      SpotlightBuilder(),
                      SizedBox(height: 20), // Space between sections
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            YourEventsSection(),
                            SizedBox(height: 20),
                            RecommendedSection()
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )


    );
  }

}



