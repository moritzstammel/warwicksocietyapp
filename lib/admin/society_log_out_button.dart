import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/authentication/FirestoreAuthentication.dart';
import 'package:warwicksocietyapp/models/society_info.dart';
import 'package:warwicksocietyapp/widgets/small_society_card.dart';

import '../authentication/SocietyAuthentication.dart';

class SocietyLogOutButton extends StatelessWidget {
  final Function notify;
  SocietyLogOutButton({Key? key,required this.notify}) : super(key: key);

  final user = FirestoreAuthentication.instance.firestoreUser!;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: logOutAsSociety,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Sign in as ",
              style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF777777),
                  fontFamily: "Inter"
              ),),
        IntrinsicWidth(
          child: Container(
            height: 28,
            padding: EdgeInsets.only(left: 2,right: 12),
            decoration: BoxDecoration(
                color: Color(0xFFF7F7F7),
                borderRadius: BorderRadius.circular(100)
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipOval(
                  child: Container(
                    color: Colors.white,
                    child: Image.network(
                      user.imageUrl, // Replace with the network image URL
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                    ),
                  ),

                ),
                SizedBox(width: 4,),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      user.fullName,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          decoration: TextDecoration.none,
                          fontFamily: "Inter"
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        )
          ],
        ),
      ),
    );
  }

  void logOutAsSociety(){
    SocietyAuthentication.instance.societyInfo = null;
    notify();
  }
}
