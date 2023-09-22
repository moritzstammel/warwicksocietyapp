import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/models/spotlight.dart';
import 'package:warwicksocietyapp/models/firestore_user.dart';
import 'package:warwicksocietyapp/authentication/society_selection_screen.dart';
import 'package:warwicksocietyapp/widgets/spotlight_card.dart';
import '../authentication/FirestoreAuthentication.dart';
import '../models/society_info.dart';

class SpotlightBuilder extends StatefulWidget {
  SpotlightBuilder({Key? key}) : super(key: key);
  final FirestoreUser user = FirestoreAuthentication.instance.firestoreUser!;

  @override
  State<SpotlightBuilder> createState() => _SpotlightBuilderState();
}

class _SpotlightBuilderState extends State<SpotlightBuilder> {

  late Stream<QuerySnapshot> spotlightStream;
  late List<String> buildSocieties;

  void setStream(){
    List<SocietyInfo> societies = List<SocietyInfo>.from(widget.user.followedSocieties.values);

    List<DocumentReference> societyRefs = societies.map((society) => society.ref).toList();
    spotlightStream = (societyRefs.isEmpty) ?
    FirebaseFirestore.instance
        .collection("universities")
        .doc("university-of-warwick")
        .collection("spotlights")
        .where('society.name', isEqualTo : 'socs' )
        .snapshots()
        :
    FirebaseFirestore.instance
        .collection("universities")
        .doc("university-of-warwick")
        .collection("spotlights")
        .where('society.ref', whereIn: societyRefs)
        .where('end_time', isGreaterThan: Timestamp.now())
        .snapshots();


      buildSocieties = societies.map((society) => society.ref.id).toList();
  }

  bool societiesWereUpdated() {
    var set1 = Set.from(buildSocieties);
    var set2 = Set.from(widget.user.followedSocieties.values.map((society) => society.ref.id));
    return set1.length != set2.length || !set1.containsAll(set2);
  }



  @override
  void initState() {
    super.initState();
    setStream();
  }



  @override
  Widget build(BuildContext context) {
    if(societiesWereUpdated()) setStream();

    return StreamBuilder<QuerySnapshot>(
      stream: spotlightStream,
      builder: (context,snapshot) {

          if (snapshot.hasError || !snapshot.hasData) return CircularProgressIndicator();

          final List<Spotlight> spotlights = snapshot.data!.docs.map((json) => Spotlight.fromJson(json.data() as Map<String,dynamic>,json.id)).toList();

          return SpotlightCard(spotlights: spotlights, editable: false,);

          
          },
      
    );
  }
}
