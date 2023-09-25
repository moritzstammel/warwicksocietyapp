import 'package:flutter/material.dart';

class SkeltonProfileScreen extends StatelessWidget {
  const SkeltonProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
              Stack(
                  children: [
                    Container(

                      height: 125,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Color(0xFFF7F7F7),
                          borderRadius: BorderRadius.circular(2)
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          SizedBox(height: 22,),
                          Container(
                            margin: EdgeInsets.only(top: 35), // Adjust as needed
                            width: 128,
                            height: 128,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white, // Set the border color to white
                                width: 4, // Set the border width
                              ),
                              color: Color(0xFFF7F7F7)
                            ),
                          ),
                          Container(height: 30,width: 160,color: Color(0xFFF7F7F7),),
                          SizedBox(height: 4,),
                          Container(height: 20,width: 100,color: Color(0xFFF7F7F7),),
                        ],
                      ),
                    ),
                  ]),
            SizedBox(height: 8),
            Divider(),


          ],
        ),
      ),
    );
  }

}
