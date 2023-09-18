import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  bool _isPasswordValid = true; // Initialize this as needed

  void _validatePassword() {
    String password = _passwordController.text.trim();
    if (password.isNotEmpty && password.length >= 6) {
      setState(() {
        _isPasswordValid = true;
      });
    } else {
      setState(() {
        _isPasswordValid = false;
      });
    }
  }

  void _sendPasswordResetEmail() async {
    try {
      await _auth.sendPasswordResetEmail(email: widget.email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password reset email sent. Please check your inbox.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to send password reset email: $e")),
      );
    }
  }

  String extractFirstNameFromEmail(String email) {
    List<String> parts = email.split(RegExp(r'[@.-]'));
    if (parts.isNotEmpty) {
      String firstName = parts.first;
      return '${firstName[0].toUpperCase()}${firstName.substring(1).toLowerCase()}';
    }
    return ''; // Return an empty string if email doesn't contain '@', '.', or '-'
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          reverse: true,
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Welcome back ${extractFirstNameFromEmail(widget.email)}!",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                  fontFamily: 'Inter',
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  errorText: _isPasswordValid ? null : "Please enter a valid password",
                  errorStyle: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
                obscureText: true,
                onChanged: (value) {
                  _validatePassword();
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  _validatePassword();
                  if (!_isPasswordValid) return;
                  // Log in button logic
                  final password = _passwordController.text;

                  _auth.signInWithEmailAndPassword(email: widget.email, password: password);
                  Navigator.pop(context);

                  String? fcmToken = await FirebaseMessaging.instance.getToken();
                  QuerySnapshot snapshot = await FirebaseFirestore.instance
                      .collection("universities")
                      .doc("university-of-warwick")
                      .collection("users")
                      .where("email",isEqualTo: widget.email)
                      .get();

                  DocumentReference ref = snapshot.docs.first.reference;
                  ref.update({"fcm_token":fcmToken});

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
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: _sendPasswordResetEmail,
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Inter',
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
