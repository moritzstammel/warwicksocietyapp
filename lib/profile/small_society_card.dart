import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/models/society_info.dart';

class SmallSocietyCard extends StatelessWidget {
  final SocietyInfo society;
  final Color backgroundColor;
  final Color textColor;
  SmallSocietyCard({Key? key, required this.society,this.backgroundColor = const Color(0xFFF7F7F7), this.textColor = Colors.black}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        height: 28,
        padding: EdgeInsets.only(left: 2,right: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(100)
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             ClipOval(
               child: Container(
                 color: Colors.white,
                 child: Image.network(
                    society.logoUrl, // Replace with the network image URL
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                  ),
               ),

             ),
           SizedBox(width: 4,),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  society.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                    decoration: TextDecoration.none,
                    fontFamily: "Inter"
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
