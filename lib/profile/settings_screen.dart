import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/authentication/FirestoreAuthentication.dart';
import 'package:warwicksocietyapp/models/firestore_user.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FirestoreUser user = FirestoreAuthentication.instance.firestoreUser!;
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset : false,
        backgroundColor: Colors.white,
        body: Container(
            margin: EdgeInsets.only(top: 28),
            padding: EdgeInsets.all(20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Icon(Icons.arrow_back),
                          ),
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/icons/profile/settings.png', // Replace with your image path
                                width: 24,
                                height: 24,
                                fit: BoxFit.contain,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 16,),
                      Text("Settings", style: TextStyle(
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w500,
                          fontSize: 18
                      ),),
                      SizedBox(height: 2,),
                      Container(
                        width: 270,

                        child: Text("Adjust app and account preferences", style: TextStyle(
                          fontFamily: "Inter",
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: Color(0xFF777777),
                        ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      SizedBox(height: 16,),

                    ],

                  ),
                ])));
  }

}
