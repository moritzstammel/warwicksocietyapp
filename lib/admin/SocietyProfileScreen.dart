import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/admin/society_log_out_button.dart';
import 'package:warwicksocietyapp/authentication/SocietyAuthentication.dart';
import 'package:warwicksocietyapp/error_screen.dart';
import 'package:warwicksocietyapp/models/society_info.dart';

import '../profile/profile_button.dart';
import '../profile/skelton_profile_screen.dart';
import '../profile/support_screen.dart';
import 'manage_society_account_screen.dart';

class SocietyProfileScreen extends StatefulWidget {
  final Function() notifyMainScreen;
  const SocietyProfileScreen({Key? key,required this.notifyMainScreen}) : super(key: key);

  @override
  State<SocietyProfileScreen> createState() => _SocietyProfileScreenState();
}

class _SocietyProfileScreenState extends State<SocietyProfileScreen> {


  void swapToUserView(){
    SocietyAuthentication.instance.logOut();
    widget.notifyMainScreen();
  }

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:
        StreamBuilder<DocumentSnapshot>(
          stream: SocietyAuthentication.instance.societyInfo!.ref.snapshots(),
          builder: (context, snapshot) {
            if(snapshot.hasError) return ErrorScreen();
            if(!snapshot.hasData) return SkeltonProfileScreen();
            SocietyInfo society = SocietyInfo.fromJson(snapshot.data!.data() as Map<String,dynamic>);
            SocietyAuthentication.instance.societyInfo = society;
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        _customPageRouteBuilder(ManageSocietyAccountScreen()),
                      ),
                      child: Stack(
                          children: [
                            Container(

                              height: 125,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage("https://firebasestorage.googleapis.com/v0/b/warwick-society-app.appspot.com/o/society-banner.png?alt=media&token=7db4aada-615a-4283-bcca-78f8ab52676f"),
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
                                        image: NetworkImage(society.logoUrl),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Text(society.name,style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold
                                  ),),
                                  SizedBox(height: 4,),
                                  Text("@${society.name}",
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
                    Divider(),
                    Column(
                      children: [
                        ProfileButton(name: "Manage Account", description: "Edit and update personal information", path: "assets/icons/profile/filter.png",
                            onTap: () => Navigator.push(
                              context,
                              _customPageRouteBuilder(ManageSocietyAccountScreen()),
                            )),
                        ProfileButton(name: "Support", description: "Notify us of problems or seek help", path: "assets/icons/profile/support.png",
                            onTap: () => Navigator.push(
                              context,
                              _customPageRouteBuilder(SupportScreen()),
                            )),
                      ],
                    ),





                  ],
                ),
                SocietyLogOutButton(notify: widget.notifyMainScreen),

              ],
            );
          }
        ),

    );
  }
}
