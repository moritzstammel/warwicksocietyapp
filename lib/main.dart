import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:warwicksocietyapp/login_screen.dart';
import 'package:warwicksocietyapp/select_email_screen.dart';
import 'package:warwicksocietyapp/sign_up_screen.dart';
import 'package:warwicksocietyapp/verification_screen.dart';
import 'firebase_options.dart';
import 'main_screen.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Screen',
      home: StreamBuilder(
        stream:FirebaseAuth.instance.userChanges(),
        builder: (BuildContext context,snapshot)
        {
          if(snapshot.connectionState==ConnectionState.waiting){
            return const CircularProgressIndicator();
          }
          else if(snapshot.hasData){
            FirebaseAuth.instance.currentUser?.reload();
            print( FirebaseAuth.instance.currentUser?.emailVerified);
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


