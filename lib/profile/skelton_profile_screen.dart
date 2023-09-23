import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/models/firestore_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:warwicksocietyapp/profile/edit_societies.dart';
import 'package:warwicksocietyapp/profile/edit_tags.dart';
import 'package:warwicksocietyapp/profile/manage_account_screen.dart';
import 'package:warwicksocietyapp/profile/profile_button.dart';
import 'package:warwicksocietyapp/profile/settings_screen.dart';
import 'package:warwicksocietyapp/profile/support_screen.dart';
import 'package:warwicksocietyapp/widgets/small_society_card.dart';
import 'package:warwicksocietyapp/widgets/society_card.dart';
import 'package:warwicksocietyapp/profile/society_log_in_button.dart';
import 'package:warwicksocietyapp/widgets/tag_card.dart';
import '../authentication/FirestoreAuthentication.dart';
import '../authentication/SocietyAuthentication.dart';
import '../home/search_screen.dart';
import '../models/society_info.dart';
class SkeltonProfileScreen extends StatelessWidget {
  const SkeltonProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirestoreUser user = FirestoreAuthentication.instance.firestoreUser!;

    print("Profile Societies:");
    print(user.followedSocieties);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
              Stack(
                  children: [
                    Container(

                      height: 125,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Color(0xFFF7F7F7),
                          borderRadius: BorderRadius.circular(2)
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          SizedBox(height: 22,),
                          Container(
                            margin: EdgeInsets.only(top: 35), // Adjust as needed
                            width: 128,
                            height: 128,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white, // Set the border color to white
                                width: 4, // Set the border width
                              ),
                              color: Color(0xFFF7F7F7)
                            ),
                          ),
                          Container(height: 30,width: 160,color: Color(0xFFF7F7F7),),
                          SizedBox(height: 4,),
                          Container(height: 20,width: 100,color: Color(0xFFF7F7F7),),
                        ],
                      ),
                    ),
                  ]),
            SizedBox(height: 8),
            Divider(),


          ],
        ),
      ),
    );
  }

}
