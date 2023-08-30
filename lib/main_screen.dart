import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/explore_screen.dart';
import 'package:warwicksocietyapp/home/home_screen.dart';
import 'package:warwicksocietyapp/authentication/login_screen.dart';
import 'package:warwicksocietyapp/profile_screen.dart';
import 'package:warwicksocietyapp/rewards_screen.dart';
import 'package:warwicksocietyapp/spotlight_creation/spotlight_overview_screen.dart';

import 'event_creation/events_overview_screen.dart';
import 'home/top_app_bar.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  PageController _pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(),
          SpotlightOverviewScreen(),
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
}


