import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/authentication/FirestoreAuthentication.dart';
import 'package:warwicksocietyapp/models/firestore_user.dart';

class SupportScreen extends StatefulWidget {
  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
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
                          'assets/icons/profile/support.png', // Replace with your image path
                          width: 24,
                          height: 24,
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 16,),
                Text("Support", style: TextStyle(
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w500,
                    fontSize: 18
                ),),
                SizedBox(height: 2,),
                Container(
                  width: 270,

                  child: Text("Please share a detailed description of your issue or request in the text field below. Including error messages, steps to reproduce, or any relevant details will assist our support team in addressing your concerns effectively.", style: TextStyle(
                    fontFamily: "Inter",
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Color(0xFF777777),
                  ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                SizedBox(height: 16,),
                Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 28,bottom: 28),
                      width: 300,
                      height: 450,
                      decoration: BoxDecoration(
                        color: Color(0xFFF7F7F7), // Use the specified background color
                        borderRadius: BorderRadius.circular(16.0), // Rounded corners
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'Type your message here', // Hint text
                            border: InputBorder.none, // Remove the default border
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            String message = _messageController.text;
                            if(message.trim() == "") return;

                            CollectionReference supportMessageCollection = FirebaseFirestore.instance
                                .collection("universities")
                                .doc("university-of-warwick")
                                .collection("support_messages");

                            supportMessageCollection.add({
                              "user_id": user.id,
                              "email" : user.email,
                              "message" : message,
                            });
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: 56,
                            width: 56,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(100)
                            ),
                            child: Center(
                              child: ImageIcon(
                                AssetImage('assets/icons/chats/send.png'),
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ))

                  ],
                ),

          ],

      ),
    ])));
  }

}
