import 'package:flutter/cupertino.dart';
import 'package:warwicksocietyapp/models/society_info.dart';
import 'package:warwicksocietyapp/profile/small_society_card.dart';

import '../authentication/SocietyAuthentication.dart';

class SocietyLogInButton extends StatelessWidget {
  final SocietyInfo society;
  final Function notify;
  const SocietyLogInButton({Key? key,required this.society,required this.notify}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: logInAsSociety,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Sign in as ",
            style: TextStyle(
                fontSize: 14,
                color: Color(0xFF777777),
                fontFamily: "Inter"
            ),),
          SmallSocietyCard(society: society),
        ],
      ),
    );
  }

  void logInAsSociety(){
    SocietyAuthentication.instance.societyInfo = society;
    notify();
  }
}
