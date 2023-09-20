import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/spotlight.dart';
import '../widgets/small_society_card.dart';

class SpotlightDetails extends StatelessWidget {
  final Spotlight spotlight;

  SpotlightDetails({
    required this.spotlight,
  });
  Container buildLinkContainer(String linkText, String url) {
    final Uri uri = Uri.parse(url);
    return Container(

      child: GestureDetector(
        onTap: () async {

          await launchUrl(uri);

        },
        child: Row(
          children: [
            Icon(
              Icons.link,
              color: Colors.black,
            ),
            SizedBox(width: 4),
            Container(
              width: 280,
              child: Text(

                linkText,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  decorationColor: Colors.black,
                  decorationStyle: TextDecorationStyle.solid,
                  decoration: TextDecoration.underline,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),
          height: 565,
          width: 360,

          padding: EdgeInsets.all(20),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SmallSocietyCard(society: spotlight.society,backgroundColor: Colors.black,textColor: Colors.white,),
                      GestureDetector(
                        onTap: Navigator.of(context).pop,
                        child: Icon(
                          Icons.close,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    spotlight.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black,
                      fontFamily: "Inter",
                      decoration: TextDecoration.none

                    ),
                  ),
                  SizedBox(height: 8),
                  SingleChildScrollView(
                    child: Container(
                      width: 280,
                      child: Text(
                        spotlight.text,
                        maxLines: 20,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.normal,
                            decoration: TextDecoration.none
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),



                ],
              ),
              Column(
                children: [
                  for (String link in spotlight.links)
                    Column(children:
                    [buildLinkContainer(link,link),
                    SizedBox(height: 8,)
                    ]),
                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}
