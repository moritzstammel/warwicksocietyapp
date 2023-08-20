import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/sign_up_screen.dart';

class SelectEmailScreen extends StatefulWidget {
  @override
  _SelectEmailScreenState createState() => _SelectEmailScreenState();
}

class _SelectEmailScreenState extends State<SelectEmailScreen> {
  TextEditingController _emailController = TextEditingController();
  bool _isValid = true;

  void _validateEmail() {
    String email = _emailController.text.trim().toLowerCase();
    if (email.endsWith("warwick.ac.uk") && email.contains("@")) {
      setState(() {
        _isValid = true;
      });
    } else {
      setState(() {
        _isValid = false;
      });
    }
  }
  void _navigateToSignUpScreen(String email){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpScreen(email: email)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Email Screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Enter your email",
                errorText: _isValid ? null : "Please enter a valid Warwick email address",
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                _validateEmail();
                if (!_isValid) return;
                final email = _emailController.text.trim().toLowerCase();
                try {
                  final docSnapshot = await FirebaseFirestore.instance
                      .collection('/universities/university-of-warwick/users')
                      .doc(email)
                      .get();

                  if(docSnapshot.exists){
                    print("gibts schon");
                  }
                  else{
                    print("gibts noch nicht");
                    _navigateToSignUpScreen(email);
                  }

                } catch (e) {
                  print("Error checking email: $e");
                }

              },
              child: Text("Continue"),
            ),
          ],
        ),
      ),
    );
  }
}