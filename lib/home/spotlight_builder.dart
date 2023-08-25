import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/models/spotlight.dart';
import 'package:warwicksocietyapp/models/user.dart';
import 'package:warwicksocietyapp/society_selection_screen.dart';
import 'package:warwicksocietyapp/widgets/spotlight_card.dart';

import '../models/society_info.dart';

class SpotlightBuilder extends StatefulWidget {
  const SpotlightBuilder({Key? key, required this.user}) : super(key: key);
  final FirestoreUser user;

  @override
  State<SpotlightBuilder> createState() => _SpotlightBuilderState();
}

class _SpotlightBuilderState extends State<SpotlightBuilder> {


  List<Spotlight> spotlightData = [];
  bool spotlightsFetched = false;


  Future<List<QueryDocumentSnapshot>> _fetchSpotlights() async {
    List<QueryDocumentSnapshot> spotlights = [];
    final CollectionReference spotlightsCollection =
    FirebaseFirestore.instance.collection('universities')
        .doc('university-of-warwick')
        .collection('spotlights');
    // Collect all society references
    List<DocumentReference> societyRefs = widget.user.followedSocieties.map((society) => society.ref).toList();

    print(societyRefs);
    // Fetch spotlights where society_ref is in the list of societyRefs
    QuerySnapshot snapshot = await spotlightsCollection
        .where('society.ref', whereIn: societyRefs)
        .get();

    spotlights.addAll(snapshot.docs);

    return spotlights;
  }


  @override
  Widget build(BuildContext context) {
    if(spotlightsFetched){
      return SpotlightCard(spotlights: spotlightData, editable: false,);
    }
    return FutureBuilder(
      future: _fetchSpotlights(),
      builder: (context,AsyncSnapshot<List<QueryDocumentSnapshot>>snapshot) {
          
          if (snapshot.connectionState == ConnectionState.done) {

            spotlightData = snapshot.data!.map((json) => Spotlight.fromJson(json.data() as Map<String,dynamic>)).toList();
            print(spotlightData.map((spotlight) => spotlight.title));
            spotlightsFetched = true;
            return SpotlightCard(spotlights: spotlightData, editable: false,);

          }
          if(spotlightData.isNotEmpty){
            return SpotlightCard(spotlights: spotlightData, editable: false,);
          }
          else{
            return CircularProgressIndicator();
          }
          
          
          },
      
    );
  }
}
