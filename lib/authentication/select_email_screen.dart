import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:warwicksocietyapp/authentication/login_screen.dart';
import 'sign_up_screen.dart'; // Import your SignUpScreen

class SelectEmailScreen extends StatefulWidget {
  @override
  _SelectEmailScreenState createState() => _SelectEmailScreenState();
}

class _SelectEmailScreenState extends State<SelectEmailScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isValid = true; // Initialize this as needed

  void _validateEmail() {
    String email = _emailController.text.trim().toLowerCase();
    if (
    email.endsWith("warwick.ac.uk")&& email.contains("@")) {
      setState(() {
        _isValid = true;
      });
    } else {
      setState(() {
        _isValid = false;
      });
    }
  }

  PageRouteBuilder _customPageRouteBuilder(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Starting offset of the incoming screen
        const end = Offset.zero; // Ending offset of the incoming screen
        const curve = Curves.easeInOut; // Transition curve

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  void  _navigateToLogInScreen(String email) {
    Navigator.push(
      context,
      _customPageRouteBuilder(LoginScreen(email: email)),
    );}


  void _navigateToSignUpScreen(String email) {
    Navigator.push(
      context,
      _customPageRouteBuilder(SignUpScreen(email: email)),
    );
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
                  "Enter your Warwick\nemail Address",
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
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter', // Use the "Inter" font
                      fontSize: 16, // Set the desired font size
                      color: Colors.black, // Set the desired font color
                    ),

                    autofocus: true, // Autofocus enabled
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    decoration: InputDecoration(
                      errorStyle: TextStyle(

                        color: Colors.red, // Set the error text color
                        fontSize: 14, // Set the error text font size

                      ),

                      hintText: "peter.griffin@warwick.ac.uk",
                      hintStyle: TextStyle(color:Color(0xFF888888)),

                      errorText: _isValid ? null : "Please enter a valid Warwick email address",

                      ),
                    cursorColor: Colors.black,

                    ),
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
            child: ElevatedButton(
              onPressed: () async {
                _validateEmail();
                if (!_isValid) return;
                final email = _emailController.text.trim().toLowerCase();
                try {
                  final docSnapshot = await FirebaseFirestore.instance
                      .collection('/universities/university-of-warwick/users')
                      .where("email", isEqualTo: email)
                      .get();

                  if (docSnapshot.size == 1) {
                    print("Already exists");
                    _navigateToLogInScreen(email);
                  } else if (docSnapshot.size == 0) {
                    print("Does not exist");
                    _navigateToSignUpScreen(email);
                  } else {
                    print("Error");
                  }
                } catch (e) {
                  print("Error checking email: $e");
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
                "Continue",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Inter',
                  color: Colors.white, // White text color
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
