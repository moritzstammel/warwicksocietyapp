import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:warwicksocietyapp/authentication/SocietyAuthentication.dart';
import 'package:warwicksocietyapp/feed/explore_screen.dart';
import 'package:warwicksocietyapp/home/home_screen.dart';
import 'package:warwicksocietyapp/authentication/login_screen.dart';
import 'package:warwicksocietyapp/profile/profile_screen.dart';
import 'package:warwicksocietyapp/rewards_screen.dart';
import 'package:warwicksocietyapp/spotlight_creation/spotlight_overview_screen.dart';
import 'dart:io';
import 'admin/SocietyProfileScreen.dart';
import 'authentication/FirestoreAuthentication.dart';
import 'event_creation/events_overview_screen.dart';
import 'home/top_app_bar.dart';
import 'models/firestore_user.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  PageController _pageController = PageController(initialPage: 1);
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

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      displayNotification(message);
    });
  }

  void displayNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'SocsChatMessageReceived', // Replace with your channel ID
      'New Chat Message', // Replace with your channel name
      importance: Importance.max,
      priority: Priority.high,
        color: const Color(0xFF000000)
    );


    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: null,
    );

    await flutterLocalNotificationsPlugin.show(
      message.notification?.title.hashCode ?? 0, // Notification ID (can be any unique value)
      message.notification?.title ?? 'Notification',
      message.notification?.body ?? 'You have a new notification',
      platformChannelSpecifics,
      payload: message.data['data'], // Optional, you can pass additional data
    );
  }


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  void refresh(){
    print("notified");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bool _isSociety = SocietyAuthentication.instance.isSociety;


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
              _isSociety ? EventOverviewScreen() : HomeScreen(),
              _isSociety ? SpotlightOverviewScreen() : ExploreScreen(),
              _isSociety ? SocietyProfileScreen(notifyMainScreen: refresh,) : ProfileScreen(notifyMainScreen: refresh,),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: (_currentIndex == 1 && !_isSociety) ? Colors.white : Colors.black,
            unselectedItemColor: Colors.grey,
            backgroundColor:(_currentIndex == 1 && !_isSociety) ? Colors.black : Colors.white,
            currentIndex: _currentIndex,
            selectedLabelStyle: const TextStyle(
              fontSize: 11,
              fontFamily: "Roboto"
            ),
            unselectedLabelStyle: const TextStyle(
                fontSize: 11,
                fontFamily: "Roboto"
            ),


            onTap: (index) {
              setState(() {
                _currentIndex = index;

                  if (Platform.isAndroid) {
                    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                      systemNavigationBarColor: (index==1 && !_isSociety) ? Colors.black : Colors.white,
                        systemNavigationBarIconBrightness: (index==1&& !_isSociety) ? Brightness.light : Brightness.dark
                    ));
                  }



              });
            },
            items: [
              customBottomNavigationBarItem("Home",0,_isSociety),
              customBottomNavigationBarItem("Explore",1,_isSociety),
              customBottomNavigationBarItem("Profile",2,_isSociety),

            ],
          ),
        );
      }
    );
  }
  BottomNavigationBarItem customBottomNavigationBarItem(String label, int index,bool isSociety){
    if(isSociety){
      switch (index){
        case 0:
          return BottomNavigationBarItem(
            icon: const ImageIcon(AssetImage('assets/icons/bottom-navigation-bar/create-events.png'),),
            label: "Events",
          );
        case 1:
          return BottomNavigationBarItem(
            icon: const ImageIcon(AssetImage('assets/icons/bottom-navigation-bar/create-spotlights.png'),),
            label: "Spotlights",
          );
      }
    }

    return BottomNavigationBarItem(
      icon: (_currentIndex == index) ? ImageIcon(
        AssetImage('assets/icons/bottom-navigation-bar/${label.toLowerCase()}-selected.png'),
      )
          :
      ImageIcon(
        AssetImage('assets/icons/bottom-navigation-bar/${label.toLowerCase()}.png'),
      )
      ,
      label: label,
    );
  }

}


