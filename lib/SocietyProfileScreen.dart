import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/authentication/SocietyAuthentication.dart';

class SocietyProfileScreen extends StatefulWidget {
  final Function() notifyMainScreen;
  const SocietyProfileScreen({Key? key,required this.notifyMainScreen}) : super(key: key);

  @override
  State<SocietyProfileScreen> createState() => _SocietyProfileScreenState();
}

class _SocietyProfileScreenState extends State<SocietyProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return  Center(
      child: ElevatedButton(onPressed: ()
        {
            SocietyAuthentication.instance.logOut();
            widget.notifyMainScreen();
        }
      , child: Text("swap to user view")),
    );
  }
}
