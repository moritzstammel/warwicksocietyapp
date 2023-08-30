import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

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
  void _closeScreen(){
    Navigator.pop(context);
  }

  Future<void> _createFirebaseUser(String email)async {
    final CollectionReference userRef = FirebaseFirestore.instance.collection(
        '/universities/university-of-warwick/users');
    await userRef.add({
      "email": email,
      "followed_societies": [],
      "events_signed_up": [],
      "events_attended": [],
      "points": 0,
      "highlights": []
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _passwordController,
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                labelText: "Password",
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
            ),
            if (!_isPasswordValid)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "Your password must be at least six characters",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                _validatePassword();
                if (!_isPasswordValid) return;
                final email = widget.email;
                final password = _passwordController.text;

                  // Handle sign up logic here
                try {
                    await _auth.createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );

                    await _createFirebaseUser(email);

                    final user = _auth.currentUser;
                    await user!.sendEmailVerification();

                    _closeScreen();
                }
                catch (e) {
                  print("Error signing up: $e");
                }
              },
              child: Text("Sign Up"),
            ),
            SizedBox(height: 10),
            RichText(
              text: TextSpan(
                text: "By clicking Sign Up, you agree to our ",
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: "Privacy Policy",
                    style: TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Handle privacy policy link logic here
                      },
                  ),
                  TextSpan(text: ". Click to learn how your data is processed."),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
