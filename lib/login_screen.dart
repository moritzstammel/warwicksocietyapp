
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: "Password",
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  final email = _emailController.text;
                  final password = _passwordController.text;
                  if (email.isEmpty || password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Email and password are required.")),
                    );
                    return;
                  }

                  // Sign in with email and password

                  final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  );


                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to log in: $e")),
                  );
                }
              },
              child: Text("Log In"),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () async {

                  final email = _emailController.text;
                  final password = _passwordController.text;
                  if (email.isEmpty || password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Email and password are required.")),
                    );
                    return;
                  }
                  createFirebaseUser(email);
                  // Create a new user with email and password
                  await _auth.createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                  );

                  // Send email verification link
                  final user = _auth.currentUser;
                  await user!.sendEmailVerification();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Verification email sent. Please verify your email.")),
                  );


              },
              child: Text("Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
  void createFirebaseUser(String email){
    final CollectionReference userRef = FirebaseFirestore.instance.collection('/universities/university-of-warwick/users');
    userRef.doc(email).set({
      "email":email,
      "followed_societies":[],
      "events_signed_up":[],
      "events_attended":[],
      "points": 0,
      "highlights":[]

    });
  }
}