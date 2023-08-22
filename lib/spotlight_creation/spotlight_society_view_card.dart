

import 'package:flutter/material.dart';

import '../models/spotlight.dart';

class SpotlightSocietyViewCard extends StatefulWidget {
  final Spotlight spotlight;
  final bool editable;

  const SpotlightSocietyViewCard({required this.spotlight,required this.editable});

  @override
  State<SpotlightSocietyViewCard> createState() => _SpotlightSocietyViewCardState();
}

class _SpotlightSocietyViewCardState extends State<SpotlightSocietyViewCard> {
  @override
  Widget build(BuildContext context) {
    ;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: widget.spotlight.image,
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.5), // Adjust opacity and color as needed
            BlendMode.darken,
          ),
        ),
      ),
      height: 150,
      child: Stack(
        children: [
          if (widget.editable) Positioned(
            top: 5,
            right: 5,
            child: GestureDetector(
              onTap: () {
                // Handle edit button press
              },
              child: Icon(
                Icons.edit,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.spotlight.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  // Handle more info button press
                },
                child: Text(
                  'More Info',
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  minimumSize: Size(100, 33),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


