import 'package:flutter/material.dart';

class ProfileButton extends StatelessWidget {
  final String name;
  final String description;
  final String path;
  final Function onTap;

  ProfileButton({
    required this.name,
    required this.description,
    required this.path,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.transparent)
          ),
          height: 60,
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Added vertical padding
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Image.asset(
                    path,
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF777777),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

    );
  }
}
