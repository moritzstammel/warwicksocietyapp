import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with WidgetsBindingObserver {
  final TextEditingController _emailController=TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signInWithEmailandLink(userEmail)async{
    var _userEmail=userEmail;
    return await _auth.sendSignInLinkToEmail(
        email: _userEmail,
        actionCodeSettings: ActionCodeSettings(
          url: "https://warwicksocietyapp.page.link/H3Ed",
          handleCodeInApp: true,
          androidPackageName:"com.socs.warwicksocietyapp",
          androidMinimumVersion: "12",
        )
    ).then((value){
      print("email sent");
    });
  }
  @override
  void initState() {
    handleDynamicLinks();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      // Handle dynamic link events when the app is resumed
      FirebaseDynamicLinks.instance.getInitialLink().then((PendingDynamicLinkData? data) {
        final Uri? deepLink = data?.link;
        if (deepLink != null) {
          handleLink(deepLink, _emailController.text);
        }
      });
    }
  }

  void handleLink(Uri link,userEmail) async {
    if (link != null) {
      print(userEmail);
      final UserCredential user = await FirebaseAuth.instance.signInWithEmailLink(
        email:userEmail,
        emailLink:link.toString(),
      );
      if (user != null) {
        print(user.credential);
      }
    } else {
      print("link is null");
    }
  }
  void handleDynamicLinks() async {
    ///To bring INTO FOREGROUND FROM DYNAMIC LINK.
    FirebaseDynamicLinks.instance.onLink.listen(
          (PendingDynamicLinkData dynamicLinkData) async {
        await _handleDeepLink(dynamicLinkData);
      },
    );

    final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
    _handleDeepLink(data!);
  }

  // bool _deeplink = true;
  _handleDeepLink(PendingDynamicLinkData data) async {

    final Uri? deeplink = data.link;
    if (deeplink != null) {
      print('Handling Deep Link | deepLink: $deeplink');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),

                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  hintText: "Type in your email address",
                  fillColor: Colors.white70),
              controller: _emailController,
            ),
            const SizedBox(
              height: 15,
            ),
            MaterialButton(onPressed: (){
              signInWithEmailandLink(_emailController.text);
            },
              color: Colors.blue,
              child: const Text("Login"),
            )
          ],
        ),
      ),
    );
  }
}