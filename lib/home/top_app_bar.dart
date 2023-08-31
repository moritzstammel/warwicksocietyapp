import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/authentication/FirestoreAuthentication.dart';
import 'package:warwicksocietyapp/chats/chat_overview_screen.dart';
import 'package:warwicksocietyapp/models/firestore_user.dart';

class TopAppBar extends StatelessWidget {
  final FirestoreUser user = FirestoreAuthentication.instance.firestoreUser!;

  TopAppBar({Key? key}) : super(key: key);

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
      height: 50,
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.black,
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Text(
                    '${user.points} points',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(Icons.chat, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    _customPageRouteBuilder(ChatOverviewScreen()),
                  );
                },
              ),
            ],
          ),

    );
  }
}


