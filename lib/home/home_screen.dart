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
      body: StreamBuilder<QuerySnapshot>(
        stream: userStream,
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

  @override
  void initState() {
    userStream = FirebaseFirestore.instance.collection("universities").doc("university-of-warwick").collection("users").where("email",isEqualTo: FirebaseAuth.instance.currentUser!.email!).snapshots();
  }
}



