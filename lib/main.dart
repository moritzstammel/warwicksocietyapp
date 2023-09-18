import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:warwicksocietyapp/authentication/FirestoreAuthentication.dart';
import 'package:warwicksocietyapp/authentication/SocietyAuthentication.dart';
import 'package:warwicksocietyapp/authentication/login_screen.dart';
import 'package:warwicksocietyapp/authentication/select_email_screen.dart';
import 'package:warwicksocietyapp/authentication/sign_up_screen.dart';
import 'package:warwicksocietyapp/authentication/society_selection_screen.dart';
import 'package:warwicksocietyapp/models/society_info.dart';
import 'package:warwicksocietyapp/verification_screen.dart';
import 'firebase_options.dart';
import 'home/home_screen.dart';
import 'main_screen.dart';



Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );




  const AndroidInitializationSettings androidInitializationSettings =
  AndroidInitializationSettings('app_icon'); // Replace 'app_icon' with your app's icon name

  final InitializationSettings initializationSettings =
  InitializationSettings(
    android: androidInitializationSettings,
    iOS: null,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  FirebaseMessaging.instance.requestPermission();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    'SocsChatMessageReceived', // Replace with your channel ID
    'New Chat Message', // Replace with your channel name
    importance: Importance.max,
    priority: Priority.high,
  );


  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: null,
  );

  await flutterLocalNotificationsPlugin.show(
    0, // Notification ID (can be any unique value)
    message.notification?.title ?? 'Notification',
    message.notification?.body ?? 'You have a new notification',
    platformChannelSpecifics,
    payload: message.data['data'], // Optional, you can pass additional data
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  



  final MaterialColor customGrey = const MaterialColor(
    0xFF424242, // Replace with your desired hex color code
    <int, Color>{
      50: Color(0xFFE0E0E0),
      100: Color(0xFFBDBDBD),
      200: Color(0xFF9E9E9E),
      300: Color(0xFF757575),
      400: Color(0xFF616161),
      500: Color(0xFF424242),
      600: Color(0xFF303030),
      700: Color(0xFF212121),
      800: Color(0xFF181818),
      900: Color(0xFF000000),
    },
  );

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        hoverColor: Colors.grey,
        indicatorColor: Colors.grey, colorScheme: ColorScheme.fromSwatch(primarySwatch: customGrey)
      ),
      home: StreamBuilder(
        stream:FirebaseAuth.instance.userChanges(),
        builder: (BuildContext context,snapshot)
        {
          if(snapshot.connectionState==ConnectionState.waiting){
            return const CircularProgressIndicator();
          }
          else if(snapshot.hasData){


            if (snapshot.data!.emailVerified){
              return MainScreen();
            }

            return VerificationScreen();

          }
          else{
            return SelectEmailScreen();
          }

        },

      ),
    );

  }
}


