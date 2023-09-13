import 'package:flutter/material.dart';

class TagCard extends StatelessWidget {
  final String name;
  final Color backgroundColor;
  final Color textColor;

  TagCard({required this.name,this.backgroundColor = const Color(0xFFF7F7F7), this.textColor = const Color(0xFF333333)});

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        height: 29,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Text(
            name,
            style: TextStyle(
              fontFamily: 'Inter',
              color: textColor,
              fontSize: 14,

            ),
          ),
        ),
      ),
    );
  }
}
