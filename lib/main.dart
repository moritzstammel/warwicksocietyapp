import 'dart:async';
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:warwicksocietyapp/login_screen.dart';

import 'firebase_options.dart';
import 'main_screen.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,

  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Screen',
      home: StreamBuilder(
        stream:FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context,snapshot)
        {
          if(snapshot.connectionState==ConnectionState.waiting){
            return const CircularProgressIndicator();
          }
          else if(snapshot.hasData){

            return MainScreen();
          }
          else{
            return LoginScreen();
          }

        },

      ),
    );

  }
}


