import 'package:flutter/material.dart';

import 'custom_search_bar.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20.0),
        margin: EdgeInsets.only(top: 20),
        child: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Enter your search query...',
            prefixIcon: Icon(Icons.search, color: Colors.black),
            filled: true,
            fillColor: Color(0xFFF7F7F7),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}

