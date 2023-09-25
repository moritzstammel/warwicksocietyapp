import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/authentication/SocietyAuthentication.dart';
import 'package:warwicksocietyapp/error_screen.dart';
import 'package:warwicksocietyapp/spotlight_creation/spotlight_creation_screen.dart';
import 'package:warwicksocietyapp/widgets/spotlight_card.dart';
import '../models/society_info.dart';
import '../models/spotlight.dart';
class SpotlightOverviewScreen extends StatefulWidget {
  const SpotlightOverviewScreen({Key? key}) : super(key: key);

  @override
  State<SpotlightOverviewScreen> createState() => _SpotlightOverviewScreenState();
}

class _SpotlightOverviewScreenState extends State<SpotlightOverviewScreen> {

  late Stream<QuerySnapshot> spotlightStream;
  late SocietyInfo buildSociety;

  void setStream(){
    final SocietyInfo society = SocietyAuthentication.instance.societyInfo!;
    spotlightStream = FirebaseFirestore.instance
        .collection("universities")
        .doc("university-of-warwick")
        .collection("spotlights")
        .where('society.ref', isEqualTo : society.ref)
        .snapshots();

    buildSociety = society;
  }


  @override
  void initState() {
    super.initState();
    setStream();
  }

  void navigateToSpotlightCreation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SpotlightCreationScreen()),
    );
  }




  @override
  Widget build(BuildContext context) {
    if(buildSociety != SocietyAuthentication.instance.societyInfo) setStream();
    return Scaffold(

      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Spotlights',
          style: TextStyle(color: Colors.black, fontFamily: 'Inter',fontSize: 22,fontWeight: FontWeight.w500),

        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: spotlightStream,
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return ErrorScreen();
          }
          final List<Spotlight> spotlightData = snapshot.data!.docs.map((json) => Spotlight.fromJson(json.data() as Map<String,dynamic>,json.id)).toList();

          final List<Spotlight> tempList  = spotlightData.where((spotlight) => spotlight.endTime.isAfter(DateTime.now())).toList();

          final Spotlight? liveSpotlight = tempList.isNotEmpty ? tempList.first : null;
          final List<Spotlight> pastSpotlights = spotlightData.where((spotlight) => spotlight.endTime.isBefore(DateTime.now())).toList();
          pastSpotlights.sort( (a,b) => a.endTime.compareTo(b.endTime));

          print(liveSpotlight);
          print(pastSpotlights);

          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
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
                SizedBox(height: 18),
                (liveSpotlight == null) ? addSpotlightButton() : SpotlightCard(spotlights: [liveSpotlight], editable: true),
                if(pastSpotlights.isNotEmpty)
                _buildPastSpotlightsSection(pastSpotlights),
              ],
            ),
          );
        }
      ),
    );
  }
  Widget addSpotlightButton(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          // Trigger the create new spotlight function
          navigateToSpotlightCreation(context);
        },
        child: Container(
          height: 150,
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
    );
  }

  Widget _buildPastSpotlightsSection(List<Spotlight> pastSpotlights) {
    if (pastSpotlights.isEmpty) return Container();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Past spotlights',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 10),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          height: 5,
          width: 50,
          decoration: BoxDecoration(
            color: Color(0xFFDD0000), // Use your desired color
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        SizedBox(height: 10),
        for (final spotlight in pastSpotlights)
          SpotlightCard(spotlights: [spotlight], editable: false)
      ],
    );
  }
}
