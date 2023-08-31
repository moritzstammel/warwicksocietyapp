import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'authentication/FirestoreAuthentication.dart';
import 'models/firestore_user.dart';

class ProfileScreen extends StatefulWidget {
  final FirestoreUser user = FirestoreAuthentication.instance.firestoreUser!;
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(

                  borderRadius: BorderRadius.all(Radius.circular(100)),
                image: DecorationImage(image: NetworkImage(widget.user.imageUrl))

              ),


            ),
            SizedBox(height: 20,),
            Text("username: ${widget.user.username}"),
            SizedBox(height: 20,),
            Text("email: ${widget.user.email}"),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: () {FirebaseAuth.instance.signOut();},
            child: Text("Sign out"),),

          ],
        )
      ),
    );
  }
}
