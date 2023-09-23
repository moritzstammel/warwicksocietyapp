import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  final String email;

  const LoginScreen({Key? key, required this.email}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _passwordController = TextEditingController();
  Timer? _countdownTimer;
  int _countdownSeconds = 30;
  bool _passwordVisible = false;
  bool _isCountingDown = false;
  bool _isValid = true;

  void startCountdown() {
    setState(() {
      _isCountingDown = true;
    });

    _countdownTimer?.cancel();
    _countdownSeconds = 30;
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdownSeconds > 0) {
          _countdownSeconds--;
        } else {
          _isCountingDown = false;
          timer.cancel();
        }
      });
    });
  }


  @override
  void dispose() {
    super.dispose();
    _countdownTimer?.cancel();
  }

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.0),
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 48,),
              Text(
                "Enter your password",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  fontFamily: 'Inter',
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 48),
              Container(
                width: 300,
                child: TextField(
                  autofocus: true,
                  keyboardType: TextInputType.visiblePassword,
                  controller: _passwordController,
                  obscureText: !_passwordVisible,//This will obscure text dynamically
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                  ),
                  decoration: InputDecoration(

                      errorStyle: TextStyle(
                        color: Colors.red, // Set the error text color
                        fontSize: 14, // Set the error text font size

                      ),



                    errorText: _isValid ? null : "You have entered an invalid password",


                    hintText: 'Enter your password',
                    // Here is key idea
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black,
                      ),
                      onPressed: () {

                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                )
              ),



              SizedBox(height: 20),
            ],
          ),

        ),

        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom ),
          child: Padding(
            // Add additional padding to create space between button and keyboard
            padding: EdgeInsets.only(bottom: 10,left: 20,right: 20),
            child: Container(
              height: 80,
              child: Column(
                children: [
                  if (!_isCountingDown)
                  Text.rich(
                    TextSpan(
                      text: "Forgot Password? ",
                      style: TextStyle(
                          color: Color(0xFF888888),
                          fontWeight: FontWeight.w500,
                          fontSize: 16
                      ),
                      children: [
                          TextSpan(
                              text: "Click here",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,

                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = (){
                                  startCountdown();
                                  _auth.sendPasswordResetEmail(email: widget.email);
                                }
                          ),
                      ],
                    ),

                    style: TextStyle(fontSize: 16.0), // Adjust the font size as needed
                  ),

                  if (_isCountingDown)
                    Text(
                      "Resend Email in $_countdownSeconds seconds",
                      style: TextStyle(
                          color: Color(0xFF888888),
                          fontWeight: FontWeight.normal,
                          fontSize: 16
                      ),),
                  SizedBox(height: 8,),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await _auth.signInWithEmailAndPassword(email: widget.email, password: _passwordController.text);
                        Navigator.pop(context);
                      }
                      catch (e) {
                       setState(() {
                         _isValid = false;
                       });


                      }

                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      minimumSize: Size(350, 50),
                      maximumSize: Size(350, 50),
                    ),
                    child: Text(
                      "Log In",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Inter',
                        color: Colors.white, // White text color
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }
}
