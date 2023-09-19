import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/spotlight_creation/spotlight_creation_screen.dart';
import 'package:warwicksocietyapp/widgets/spotlight_card.dart';

import '../models/society_info.dart';
import '../models/spotlight.dart';
class SpotlightOverviewScreen extends StatelessWidget {
  void navigateToSpotlightCreation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SpotlightCreationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Spotlights',
          style: TextStyle(color: Colors.black, fontFamily: 'Inter'),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () {
                  // Trigger the create new spotlight function
                  navigateToSpotlightCreation(context);
                },
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[200],
                          ),
                        ),
                        Icon(
                          Icons.add,
                          size: 40,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            _buildLiveSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Live',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 10),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          height: 5,
          width: 50,
          decoration: BoxDecoration(
            color: Colors.green, // Use your desired color
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        SizedBox(height: 10),
        for (int i = 0; i < 2; i++)
          Container(
            width: double.infinity, // Fill the entire width of the screen
            child: SpotlightCard(
              spotlights: [
                Spotlight(
                title: 'Piano\nNewsletter',
                text: 'Spotlight text goes here.',
                society: SocietyInfo(
                    name: "Warwick Piano Society",
                    logoUrl: "https://www.warwicksu.com/asset/Organisation/7883/Newest%20Piano%20Soc%20Logo.png?thumbnail_width=300&thumbnail_height=300&resize_type=ResizeFitAllFill",
                    ref:FirebaseFirestore.instance.doc("/universities/university-of-warwick/societies/S3lJHuxEAzhBlIx1EVED")
                ),
                image: const AssetImage("assets/spotlights_background_image.jpg"),
                  links: []
              ),
              ],
              editable: true,
            ),
          ),
      ],
    );
  }
}
