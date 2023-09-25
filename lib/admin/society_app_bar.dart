import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/admin/society_chat_overview_screen.dart';
import 'package:warwicksocietyapp/authentication/FirestoreAuthentication.dart';
import 'package:warwicksocietyapp/models/firestore_user.dart';

class SocietyAppBar extends StatelessWidget {
  final FirestoreUser user = FirestoreAuthentication.instance.firestoreUser!;

  SocietyAppBar({Key? key}) : super(key: key);

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
    return Container(

      margin: EdgeInsets.only(top: 24),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              Text(
              'Events',
              style: TextStyle(color: Colors.black, fontFamily: 'Inter',fontSize: 22,fontWeight: FontWeight.w500),
            ),
              IconButton(
                icon:  ImageIcon(
                  AssetImage('assets/icons/chats/chat.png'),
                  size: 30,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    _customPageRouteBuilder(SocietyChatOverviewScreen()),
                  );
                },
              ),
            ],
          ),

        ],
      ),

    );
  }
}


