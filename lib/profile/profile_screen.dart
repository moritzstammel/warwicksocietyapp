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

class ProfileScreen extends StatefulWidget {
  final Function() notifyMainScreen;

  ProfileScreen({super.key, required this.notifyMainScreen});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Stream<QuerySnapshot> administeredSocietyStream;



  PageRouteBuilder _customPageRouteBuilder(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Starting offset of the incoming screen
        const end = Offset.zero; // Ending offset of the incoming screen
        const curve = Curves.easeInOut; // Transition curve

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  void openEdit(Widget screen){
    showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: "",
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: screen,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
    );
  }


  @override
  void initState() {
    super.initState();
    FirestoreUser user = FirestoreAuthentication.instance.firestoreUser!;

    administeredSocietyStream =
    FirebaseFirestore.instance
        .collection("universities")
        .doc("university-of-warwick")
        .collection("societies")
        .where("admins.${user.id}",isEqualTo: true)
        .snapshots();

  }

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
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                _customPageRouteBuilder(ManageAccountScreen()),
              ),
              child: Stack(
                children: [
                  Container(

                    height: 125,
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
                          margin: EdgeInsets.only(top: 35), // Adjust as needed
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
                        Text(user.fullName,style: TextStyle(
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
            ),



            SizedBox(height: 8),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
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
                            openEdit(EditSocieties());
                          },
                        ),
                      ],
                    ),
                  if(user.followedSocieties.isNotEmpty)
                  Container(

                    height: 108, // Set an appropriate height
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: user.followedSocieties.values.length,
                      itemBuilder: (context, index) {
                        return SocietyCard(societyInfo: user.followedSocieties.values.toList()[index]);
                      },
                    ),
                  ),
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
                          icon: Icon(Icons.edit, size: 16), // Adjust the size as needed
                          onPressed: () {
                            openEdit(EditTags());
                          },
                        ),
                      ],
                    ),

                   Wrap(
                     spacing: 8,
                     runSpacing: 8,
                     children: user.tags.keys.map((tagName) => TagCard(name: tagName)).toList(),
                    ),

                ],
              ),
            ),





            SizedBox(height: 8),
            Divider(),
            Column(
              children: [
                ProfileButton(name: "Manage Account", description: "Edit and update personal information", path: "assets/icons/profile/filter.png",
                    onTap: () => Navigator.push(
                      context,
                      _customPageRouteBuilder(ManageAccountScreen()),
                    )),
                ProfileButton(name: "Settings", description: "Adjust app and account preferences", path: "assets/icons/profile/settings.png",
                    onTap: () => Navigator.push(
                      context,
                      _customPageRouteBuilder(SettingsScreen()),
                    )),
                ProfileButton(name: "Support", description: "Notify us of problems or seek help", path: "assets/icons/profile/support.png",
                    onTap: () => Navigator.push(
                  context,
                  _customPageRouteBuilder(SupportScreen()),
                )),
              ],
            ),

           StreamBuilder(
             stream: administeredSocietyStream,
               builder:(context, snapshot) {
                 if(snapshot.hasData){
                   List<SocietyInfo> administeredSocieties = snapshot.data!.docs.map((soc) => SocietyInfo.fromJson(soc.data() as Map<String,dynamic>)).toList();
                   return Column(
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                          for (final society in administeredSocieties)
                            SocietyLogInButton(society:society,notify: widget.notifyMainScreen)
                     ],
                   );
                 }
                 return Container();

               })



          ],
        ),
      ),
    );
  }
  Future<void> createChats() async{
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('universities')
        .doc('university-of-warwick')
        .collection('societies')
        .get();


      final allSocieties = snapshot.docs.map((doc) => SocietyInfo.fromJson(doc.data() as Map<String, dynamic>)).toList();
      for (final society in allSocieties ){

        Map<String, dynamic> newChat = {
          "type": "society_chat",
          "event": null,
          "last_time_message_sent" : null,
          "messages" : [],
          "society" : {
            "name": society.name,
            "ref": society.ref,
            "logo_url":  society.logoUrl,
          },
          "users" : {}
        };

        CollectionReference chatCollection = FirebaseFirestore.instance
            .collection("universities")
            .doc("university-of-warwick")
            .collection("chats");

        chatCollection.add(newChat);
      }

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
