import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({Key? key}) : super(key: key);

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  late Timer _timer;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Timer? _countdownTimer;
  int _countdownSeconds = 30;
  bool _isCountingDown = false;

  @override
  void initState() {
    super.initState();
    // Start a periodic timer to reload user data every 1 second
    _auth.currentUser!.sendEmailVerification();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      FirebaseAuth.instance.currentUser!.reload();
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the screen is disposed
    _countdownTimer?.cancel();
    _timer.cancel();
    super.dispose();
  }
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: _auth.signOut,
            child: Container(
              margin: EdgeInsets.all(20),
                height: 20,
                width: 20,
                child: Center(child: Icon(Icons.close,size: 28,color: Colors.black,))),
          )
        ],
      ),

      body: Container(
        padding: EdgeInsets.all(20),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 24,),
                    Text("Almost there!", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Inter",
                      fontSize: 24,
                      color: Colors.black
                    ),),
                    SizedBox(height: 48,),
                    Text("Just follow the link we sent to:", style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: "Inter",
                        fontSize: 16,
                        color: Color(0xFF888888)
                    ),),
                    SizedBox(height: 8,),
                    Text(FirebaseAuth.instance.currentUser!.email!, style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: "Inter",
                        fontSize: 16,
                        color: Colors.black
                    ),),


                  ],
                ),
                const ImageIcon(AssetImage('assets/icons/profile/big-mail.png'),size: 132,),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () => FirebaseAuth.instance.currentUser!.reload(),
                      child: Container(
                        width: 350,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(100)
                        ),
                        child: Center(child: Text("Proceed",style: TextStyle(
                            color: Colors.white,fontSize: 16,fontWeight: FontWeight.w500,fontFamily: "Inter"
                        ),),),
                      ),
                    ),
                    SizedBox(height: 16,),
                    Text.rich(
                      TextSpan(
                        text: "Didn't receive an email? ",
                        style: TextStyle(
                            color: Color(0xFF888888),
                            fontWeight: FontWeight.w500,
                            fontSize: 16
                        ),
                        children: [
                          if (!_isCountingDown)
                          TextSpan(
                            text: "Resend",
                            style: TextStyle(
                                decoration: TextDecoration.underline,

                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 16
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = (){
                                  startCountdown();
                                  _auth.currentUser!.sendEmailVerification();
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
                        ),)
                  ],
                )

          ],
        ),
      ),
    );
  }
  void resendEmail() async {

  }
}
