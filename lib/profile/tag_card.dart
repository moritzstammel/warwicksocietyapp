import 'package:flutter/material.dart';

class TagCard extends StatelessWidget {
  final String name;

  TagCard({required this.name});

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        height: 29,
        decoration: BoxDecoration(
          color: Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Text(
            name,
            style: TextStyle(
              fontFamily: 'Inter',
              color: Color(0xFF333333),
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
