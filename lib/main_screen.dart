import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/feed/explore_screen.dart';
import 'package:warwicksocietyapp/home/home_screen.dart';
import 'package:warwicksocietyapp/authentication/login_screen.dart';
import 'package:warwicksocietyapp/profile_screen.dart';
import 'package:warwicksocietyapp/rewards_screen.dart';
import 'package:warwicksocietyapp/spotlight_creation/spotlight_overview_screen.dart';

import 'authentication/FirestoreAuthentication.dart';
import 'event_creation/events_overview_screen.dart';
import 'home/top_app_bar.dart';
import 'models/firestore_user.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 1;
  PageController _pageController = PageController(initialPage: 0);
  late Stream<QuerySnapshot> userStream;

  @override
  void initState() {
    super.initState();
    userStream = FirebaseFirestore.instance
        .collection("universities")
        .doc("university-of-warwick")
        .collection("users")
        .where("email",isEqualTo: FirebaseAuth.instance.currentUser!.email!)
        .snapshots();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
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

        FirestoreAuthentication.instance.firestoreUser = FirestoreUser.fromJson(snapshot.data!.docs[0].data() as Map<String, dynamic>,snapshot.data!.docs[0].id);

        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: [
              HomeScreen(),
              ExploreScreen(),
              EventOverviewScreen(),
              ProfileScreen(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.event),
                label: 'Events',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.card_giftcard),
                label: 'Rewards',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        );
      }
    );
  }
}


