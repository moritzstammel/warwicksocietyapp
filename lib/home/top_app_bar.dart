import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopAppBar extends StatelessWidget {
  const TopAppBar({Key? key}) : super(key: key);

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
                    '1600 points',
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


