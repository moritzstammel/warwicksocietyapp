import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopAppBar extends StatefulWidget {
  const TopAppBar({Key? key}) : super(key: key);

  @override
  State<TopAppBar> createState() => _TopAppBarState();
}

class _TopAppBarState extends State<TopAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 40, left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Points: 100', style: TextStyle(fontSize: 18, color: Colors.black)),
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
