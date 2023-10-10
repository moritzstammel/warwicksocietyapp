import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/authentication/society_selection_screen.dart';
import 'package:warwicksocietyapp/firestore_helper.dart';

class SignUpScreen extends StatefulWidget {
  final String email;

  SignUpScreen({required this.email});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {


  final _auth = FirebaseAuth.instance;
  TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;
  bool _isPasswordValid = true;

  String emailToFullName(String email) {
    // Remove the @warwick.ac.uk from the end
    email = email.replaceAll(RegExp(r'@warwick\.ac\.uk$'), '');

    // Replace "." and "-" with a space
    email = email.replaceAll(RegExp(r'[.-]'), ' ');

    // Split the string by spaces, capitalize each word, and join them back
    email = email.split(' ').map((word) {
      if (word.isNotEmpty) {
        return word[0].toUpperCase() + word.substring(1);
      }
      return word;
    }).join(' ');

    return email;
  }

  void _validatePassword() {
    String password = _passwordController.text;

    if (password.length < 6) {
      setState(() {
        _isPasswordValid = false;
      });
    } else {
      setState(() {
        _isPasswordValid = true;
      });
    }
  }
  void _navigateToSocietySelection(DocumentReference userRef){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SocietySelectionScreen(userRef: userRef),
    ));
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



                    errorText: _isPasswordValid ? null : "Password should be at least 6 characters.",


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
                Text.rich(
                  TextSpan(
                    text: "By clicking Sign Up, you agree to our ",
                    style: TextStyle(
                      color: Color(0xFF888888),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    children: [
                      TextSpan(
                        text: "Privacy Policy",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(
                        text: ".",
                        style: TextStyle(
                          color: Color(0xFF888888),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  style: TextStyle(fontSize: 14.0),
                  textAlign: TextAlign.center,// Adjust the font size as needed
                ),




                SizedBox(height: 10,),
                ElevatedButton(
                  onPressed: () async {
                    _validatePassword();
                    if(!_isPasswordValid) return;
                    try{
                      await _auth.createUserWithEmailAndPassword(email: widget.email, password: _passwordController.text);
                      DocumentReference userRef = await FirestoreHelper.instance.createFirestoreUser(widget.email);
                      _navigateToSocietySelection(userRef);
                    }
                    catch(e){}

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
                    "Sign up",
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
