import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/authentication/society_selection_screen.dart';

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

  Future<DocumentReference> _createFirebaseUser(String email)async {
    final CollectionReference userRef = FirebaseFirestore.instance.collection(
        '/universities/university-of-warwick/users');

    String username = email.split('@')[0];

    return await userRef.add({
      "email": email,
      "followed_societies": [],
      "points": 0,
      "username" :username,
      "image_url" : "https://firebasestorage.googleapis.com/v0/b/warwick-society-app.appspot.com/o/default_profile_image.png?alt=media"
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

                    DocumentReference userRef = await _createFirebaseUser(email);

                    final user = _auth.currentUser;
                    await user!.sendEmailVerification();

                    _navigateToSocietySelection(userRef);
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
