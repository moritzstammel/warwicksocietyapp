import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/models/firestore_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:warwicksocietyapp/profile/profile_button.dart';
import 'package:warwicksocietyapp/widgets/small_society_card.dart';
import 'package:warwicksocietyapp/profile/society_card.dart';
import 'package:warwicksocietyapp/profile/society_log_in_button.dart';
import 'package:warwicksocietyapp/widgets/tag_card.dart';
import '../authentication/FirestoreAuthentication.dart';
import '../authentication/SocietyAuthentication.dart';
import '../home/search_screen.dart';
import '../models/society_info.dart';

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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
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
                    borderRadius: BorderRadius.circular(2)
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
                          border: Border.all(
                            color: Colors.white, // Set the border color to white
                            width: 4, // Set the border width
                          ),
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



            SizedBox(height: 18),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                     Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'SOCIETIES',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit,size: 16,),
                          onPressed: () {
                            // Handle edit action
                          },
                        ),
                      ],
                    ),

                  Container(

                    height: 108, // Set an appropriate height
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: user.followedSocieties.length,
                      itemBuilder: (context, index) {
                        return SocietyCard(societyInfo: user.followedSocieties[index]);
                      },
                    ),
                  )



               ,
              

                     Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'INTERESTED IN',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit, size: 20), // Adjust the size as needed
                          onPressed: () {
                            // Handle edit action
                          },
                        ),
                      ],
                    ),

                   Wrap(
                     spacing: 8,
                     runSpacing: 8,
                     children: user.tags.keys.map((tagName) => GestureDetector(
                         onTap: () => Navigator.push(
                           context,
                           MaterialPageRoute(
                             builder: (context) => SearchScreen(onlyShowSelectedOptions: true,selectedTags: [tagName],),
                           ),
                         ),
                         child: TagCard(name: tagName))).toList(),
                    ),

                ],
              ),
            ),





            SizedBox(height: 16),
            Divider(),
            Column(
              children: [
                ProfileButton(name: "Manage Account", description: "Lorem ipsum dolor sit amet consecte", path: "assets/icons/profile/filter.png", onTap: () => print("Manage Account")),
                ProfileButton(name: "Settings", description: "Lorem ipsum dolor sit amet consecte", path: "assets/icons/profile/settings.png", onTap: () => print("Settings")),
                ProfileButton(name: "Support", description: "Lorem ipsum dolor sit amet consecte", path: "assets/icons/profile/support.png", onTap: () => FirebaseAuth.instance.signOut()),
              ],
            ),
            SocietyLogInButton(society:user.followedSocieties[0],notify: widget.notifyMainScreen),


          ],
        ),
      ),
    );
  }
  Future<void> createTags() async {
    final List<String> tags = [
      "Academic",
      "Arts & Culture",
      "Sports & Fitness",
      "Music",
      "Workshops",
      "Networking",
      "Community Service",
      "Food & Dining",
      "Environment",
      "Tech & Innovation",
      "Health & Wellness",
      "Fashion",
      "Politics",
      "Film & Media",
      "Travel",
      "Gaming",
      "Diversity",
      "Science & Tech",
      "Religion & Spirituality",
    ];
    final CollectionReference tagsCollection =
    FirebaseFirestore.instance.collection('universities/university-of-warwick/tags');

    for (String tagName in tags) {
      await tagsCollection.doc(tagName).set({
        'name': tagName,
      });
    }
  }
}
