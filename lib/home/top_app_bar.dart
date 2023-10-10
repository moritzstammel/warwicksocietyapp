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
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,


      actions: <Widget>[
        GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                _customPageRouteBuilder(ChatOverviewScreen()),
              );
            },
            child:  Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.all(4),
                      child: ImageIcon(
                        AssetImage('assets/icons/chats/chat.png'),
                        color: Colors.black,
                        size: 32,
                      ),
                    ),
                    if(user.unreadChats.isNotEmpty)
                    Positioned(
                        top: 0,
                        right: 0,
                        child: Container(height: 16,width: 16,
                          child: Center(
                            child: Container(
                              child: user.unreadChats.length <= 9 ? Align(alignment: Alignment.center,child: Text(user.unreadChats.length.toString(), textAlign: TextAlign.center,style: TextStyle(fontSize: 9,color: Colors.white,fontFamily: "Inter",fontWeight: FontWeight.w500),),):null,
                              height: 14,
                              width: 14,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.red
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(

                              borderRadius: BorderRadius.circular(100),

                              color: Colors.white
                          ),))
                  ],
                ),
              ),
            )

        ),
      ],


    );
  }
}


