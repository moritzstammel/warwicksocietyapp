import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/models/firestore_user.dart';

class TopAppBar extends StatelessWidget {
  final FirestoreUser user;

  const TopAppBar({Key? key, required this.user}) : super(key: key);

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
                  // Add your action for the notification icon here
                },
              ),
            ],
          ),

    );
  }
}


