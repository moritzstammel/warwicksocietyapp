import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpButton extends StatefulWidget {
  @override
  _SignUpButtonState createState() => _SignUpButtonState();
}

class _SignUpButtonState extends State<SignUpButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isPressed = !_isPressed;
        });
      },
      child: AnimatedContainer(
        width: 80,
        height: 30,
        duration: Duration(milliseconds: 300), // Adjust the duration as needed
        decoration: BoxDecoration(
          color: _isPressed ?Color(0xFFFFF1F1): Colors.white,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: _isPressed
              ? Icon(
            Icons.close,
            color: Color(0xFFDD0000),
            size: 18,
          )
              : Text(
            "Sign up",
            style: TextStyle(
              fontFamily: "Inter",
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

