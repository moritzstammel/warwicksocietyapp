import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/home/spotlight_widget.dart';
import 'package:warwicksocietyapp/models/spotlight.dart';
import 'package:warwicksocietyapp/society_selection_screen.dart';

import '../models/society_info.dart';

class SpotlightBox extends StatefulWidget {
  const SpotlightBox({Key? key}) : super(key: key);

  @override
  State<SpotlightBox> createState() => _SpotlightBoxState();
}

class _SpotlightBoxState extends State<SpotlightBox> {



  
  List<SocietyInfo> societies = [SocietyInfo(name: "Warwick Piano Society", logoUrl: "test", ref: FirebaseFirestore.instance.doc(("/universities/university-of-warwick/societies/S3lJHuxEAzhBlIx1EVED")))];
  List<Spotlight> spotlightData = [];
  bool spotlightsFetched = false;


  Future<List<QueryDocumentSnapshot>> _fetchSpotlights() async {
    List<QueryDocumentSnapshot> spotlights = [];
    final CollectionReference spotlightsCollection =
    FirebaseFirestore.instance.collection('universities')
        .doc('university-of-warwick')
        .collection('spotlights');
    // Collect all society references
    List<DocumentReference> societyRefs = societies.map((society) => society.ref).toList();

    // Fetch spotlights where society_ref is in the list of societyRefs
    QuerySnapshot snapshot = await spotlightsCollection
        .where('society_ref', whereIn: societyRefs)
        .get();

    spotlights.addAll(snapshot.docs);

    return spotlights;
  }


  @override
  Widget build(BuildContext context) {
    if(spotlightsFetched){
      return SpotlightWidget(spotlights: spotlightData);
    }
    return FutureBuilder(
      future: _fetchSpotlights(),
      builder: (context,AsyncSnapshot<List<QueryDocumentSnapshot>>snapshot) {
          
          if (snapshot.connectionState == ConnectionState.done) {

            spotlightData = snapshot.data!.map((json) => Spotlight.fromJson(json.data() as Map<String,dynamic>)).toList();
            print(spotlightData.map((spotlight) => spotlight.title));
            spotlightsFetched = true;
            return SpotlightWidget(spotlights: spotlightData);

          }
          if(spotlightData.isNotEmpty){
            return SpotlightWidget(spotlights: spotlightData);
          }
          else{
            return CircularProgressIndicator();
          }
          
          
          },
      
    );
  }
}
