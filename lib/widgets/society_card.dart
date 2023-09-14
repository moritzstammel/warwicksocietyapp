import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../home/search_screen.dart';
import '../models/society_info.dart';

class SocietyCard extends StatelessWidget {
  final SocietyInfo societyInfo;

  SocietyCard({required this.societyInfo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchScreen(selectedSocieties: [societyInfo],),
      ),
    ),
      child: Container(
        margin: EdgeInsets.only(right: 14),
        width: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16), // Rounded corners
                image: DecorationImage(
                  image: NetworkImage(societyInfo.logoUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 8), // Spacing
            Text(
              societyInfo.name,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
