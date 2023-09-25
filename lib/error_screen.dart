import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(20),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 48,),
                Text("This is not looking great", style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "Inter",
                    fontSize: 24,
                    color: Colors.black
                ),),
                SizedBox(height: 48,),
                Text("oh lol, this is not supposed to happen\nplease restart the app and contact\nthe support to make this app a better place", style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: "Inter",
                    fontSize: 16,
                    color: Color(0xFF888888)
                ),textAlign: TextAlign.center,),
                SizedBox(height: 8,),
              ],
            ),
            const ImageIcon(AssetImage('assets/icons/profile/error.png'),size: 132,),
            Column(
              children: [
                GestureDetector(
                  child: Container(
                    width: 350,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(100)
                    ),
                    child: Center(child: Text("Contact Support",style: TextStyle(
                        color: Colors.white,fontSize: 16,fontWeight: FontWeight.w500,fontFamily: "Inter"
                    ),),),
                  ),
                ),
                SizedBox(height: 16,),
              ],
            )

          ],
        ),
      ),
    );
  }
}
