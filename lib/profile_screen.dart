import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/models/firestore_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'authentication/FirestoreAuthentication.dart';
import 'authentication/SocietyAuthentication.dart';
import 'models/society_info.dart';

class ProfileScreen extends StatefulWidget {
  final Function() notifyMainScreen;

  ProfileScreen({required this.notifyMainScreen});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {


  String emailToFullName(String email) {
    // Remove the @warwick.ac.uk from the end
    email = email.replaceAll(RegExp(r'@warwick\.ac\.uk$'), '');

    // Replace "." and "-" with a space
    email = email.replaceAll(RegExp(r'[.-]'), ' ');

    // Split the string by spaces, capitalize each word, and join them back
    email = email.split(' ').map((word) {
      if (word.isNotEmpty) {
        return word[0].toUpperCase() + word.substring(1);
      }
      return word;
    }).join(' ');

    return email;
  }

  @override
  Widget build(BuildContext context) {
    // Replace these URLs with the actual image URLs you want to use
    FirestoreUser user = FirestoreAuthentication.instance.firestoreUser!;


    return Scaffold(

      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(user.bannerUrl),
                    fit: BoxFit.cover,
                   ),
                  ),
              ),
              Align(
                alignment: Alignment.center,
                child: Column(

                  children: [
                    SizedBox(height: 22,),
                    Container(
                      margin: EdgeInsets.only(top: 60), // Adjust as needed
                      width: 128,
                      height: 128,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(user.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Text(emailToFullName(user.email),style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold
                    ),),
                    SizedBox(height: 4,),
                    Text("@${user.username}",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Color(0xFF888888)
                      ),)
                  ],
                ),
              ),
            ]),


          // Replace with your societies and tags sections
          SizedBox(height: 20),
          Text("Societies Section"),
          SizedBox(height: 20),
          Text("Tags Section"),
          SizedBox(height: 20),
          Divider(), // Add a divider for separation
          // Replace with your settings items
          ListTile(
            title: Text("Settings"),
            onTap: () {
              // Navigate to the settings page
              // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
            },
          ),
          ListTile(
            title: Text("Impressum"),
            onTap: () {
              FirebaseAuth.instance.signOut();
              // Navigate to the impressum page
              // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => ImpressumScreen()));
            },
          ),
          ListTile(
            title: Text("Log in as ChemSoc"),
            onTap: () {
              SocietyAuthentication.instance.societyInfo = SocietyInfo(name: 'ChemSoc', logoUrl: 'https://www.warwicksu.com/asset/Organisation/4097/Asset%2033.png?thumbnail_width=300&thumbnail_height=300&resize_type=ResizeFitAllFill', ref: FirebaseFirestore.instance.doc('/universities/university-of-warwick/societies/6ZsW3rpJgdV9eC0BsCR6'));
              widget.notifyMainScreen();


              // Navigate to the manage account page
              // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => ManageAccountScreen()));
            },
          ),
          ListTile(
            title: Text("Log in as Data Science Soc"),
            onTap: () {
              SocietyAuthentication.instance.societyInfo = SocietyInfo(name: 'Warwick Data Science Society', logoUrl: 'https://www.warwicksu.com/asset/Organisation/59230/icon_gr.png?thumbnail_width=300&thumbnail_height=300&resize_type=ResizeFitAllFill', ref: FirebaseFirestore.instance.doc('/universities/university-of-warwick/societies/T1ZQgaCSkpk5jCfrjad9'));
              widget.notifyMainScreen();


              // Navigate to the manage account page
              // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => ManageAccountScreen()));
            },
          ),
        ],
      ),
    );
  }
}
