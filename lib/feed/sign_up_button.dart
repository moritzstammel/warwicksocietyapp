
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/authentication/FirestoreAuthentication.dart';
import 'package:warwicksocietyapp/models/event.dart';

class SignUpButton extends StatefulWidget {
  final Event event;
  final Function additionalBehaviour;

  SignUpButton({required this.event,required this.additionalBehaviour});

  @override
  _SignUpButtonState createState() => _SignUpButtonState();
}

class _SignUpButtonState extends State<SignUpButton> {
  late bool _isRegistered;


  void changeSignUpState() async{
      return;
      DocumentReference eventRef = FirebaseFirestore.instance.doc("universities/university-of-warwick/events/${widget.event.id}");
      DocumentReference chatRef = FirebaseFirestore.instance.doc("universities/university-of-warwick/chats/${widget.event.id}");
      String userId = FirestoreAuthentication.instance.firestoreUser!.id;

      Map<String,dynamic> updatedEventUsers = {
        'registered_users.$userId': !_isRegistered
      };
      Map<String,dynamic> updatedChatUsers = {
        'user_ids.$userId': !_isRegistered
      };

      final batch = FirebaseFirestore.instance.batch();
      batch.update(eventRef, updatedEventUsers);
      batch.update(chatRef, updatedChatUsers);
      await batch.commit();



  }


  @override
  void initState() {
    super.initState();

    String userId = FirestoreAuthentication.instance.firestoreUser!.id;

    _isRegistered = (widget.event.registeredUsers.containsKey(userId) && widget.event.registeredUsers[userId] == true);

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {


        changeSignUpState();
        if(!_isRegistered) widget.additionalBehaviour();
        setState(() {
          _isRegistered = !_isRegistered;
        });
      },
      child: AnimatedContainer(
        width: 80,
        height: 30,
        duration: Duration(milliseconds: 300), // Adjust the duration as needed
        decoration: BoxDecoration(
          color: _isRegistered ?Color(0xFFFFF1F1): Colors.white,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: _isRegistered
              ? Icon(
            Icons.close,
            color: Color(0xFFDD0000),
            size: 18,
          )
              : Text(
            "Sign up",
            style: TextStyle(
              fontFamily: "Inter",
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

