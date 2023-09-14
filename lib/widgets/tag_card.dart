import 'package:flutter/material.dart';

import '../home/search_screen.dart';

class TagCard extends StatelessWidget {
  final String name;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;

  TagCard({required this.name,this.backgroundColor = const Color(0xFFF7F7F7), this.textColor = const Color(0xFF333333),this.borderColor = Colors.transparent});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchScreen(selectedTags: [name],),
        ),
      ),
      child: IntrinsicWidth(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          height: 29,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(100),
              border: Border.all(color: borderColor)
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
      ),
    );
  }
}
