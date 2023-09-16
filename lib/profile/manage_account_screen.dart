import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/authentication/FirestoreAuthentication.dart';
import 'package:warwicksocietyapp/models/firestore_user.dart';

class ManageAccountScreen extends StatefulWidget {
  @override
  _ManageAccountScreenState createState() => _ManageAccountScreenState();
}

class _ManageAccountScreenState extends State<ManageAccountScreen> {
  final FirestoreUser user = FirestoreAuthentication.instance.firestoreUser!;
  TextEditingController nameController = TextEditingController(text: FirestoreAuthentication.instance.firestoreUser!.fullName);
  TextEditingController usernameController = TextEditingController(text: "@${FirestoreAuthentication.instance.firestoreUser!.username}");

  bool _textModified = false;

  String formatDateTime(DateTime dateTime) {
    final monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August',
      'September', 'October', 'November', 'December'
    ];

    final day = dateTime.day.toString().padLeft(2, '0');
    final month = monthNames[dateTime.month - 1];
    final year = dateTime.year.toString();

    return '$day. $month $year';
  }



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
                          'assets/icons/profile/filter.png', // Replace with your image path
                          width: 24,
                          height: 24,
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 16,),
                Text("Manage Account", style: TextStyle(
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w500,
                    fontSize: 18
                ),),
                SizedBox(height: 2,),
                Text("Edit and update personal information", style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  color: Color(0xFF777777),
                ),),
                SizedBox(height: 16,),
                Stack(
                  children: [
                    Container(
                      width: 128,
                      height: 128,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 4,
                        ),
                        image: DecorationImage(
                          image: NetworkImage(user.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(100)
                        ),
                        child: Center(
                          child: ImageIcon(
                            AssetImage('assets/icons/profile/edit_white.png'),
                            size: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )

                  ],
                ),
                SizedBox(height: 8,),
                TextFormField(
                  onChanged: (text) => setState(() {
                    _textModified = true;
                  }),
                  style: TextStyle(
                      fontFamily: "Inter",
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                  ),
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Name",
                    labelStyle: TextStyle(
                        fontFamily: "Inter",
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Colors.black
                    ),
                    suffixIcon: ImageIcon(
                      AssetImage('assets/icons/profile/edit_black.png'),
                      size: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  onChanged: (text) => setState(() {
                    _textModified = true;
                  }),
                  style: TextStyle(
                      fontFamily: "Inter",
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF888888)
                  ),
                  controller: usernameController,

                  decoration: InputDecoration(
                    labelText: "Username",
                    counterStyle: TextStyle(fontSize: 23),
                    suffixIcon: ImageIcon(
                        AssetImage('assets/icons/profile/edit_black.png'),
                        size: 16,
                        color: Colors.black),
                    labelStyle: TextStyle(
                        fontFamily: "Inter",
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Colors.black
                    ),
                  ),
                ),
                SizedBox(height: 24,),
                Text("Email",style: TextStyle(
                    fontFamily: "Inter",
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                    color: Colors.black
                ),),
                SizedBox(height: 8,),
                Text(user.email,style: TextStyle(
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.black
                ),),
                SizedBox(height: 16,),
                Text("Date joined",style: TextStyle(
                    fontFamily: "Inter",
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                    color: Colors.black
                ),),
                SizedBox(height: 8,),
                Text(formatDateTime(user.createdAt),style: TextStyle(
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.black
                ),),
                SizedBox(height: 24,),
                GestureDetector(
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pop(context);
                  },
                  child: Text("Sign Out",style: TextStyle(
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Color(0xFFDD0000)
                  ),),
                ),
              ],
            ),
            if(_textModified)
            GestureDetector(
              onTap: (){

              },
              child: Container(
                width: 130,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Text(
                    "Save changes",
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
