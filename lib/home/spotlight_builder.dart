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


  @override
  void initState() {
    super.initState();
    List<DocumentReference> societyRefs = widget.user.followedSocieties.map((society) => society.ref).toList();
    spotlightStream = FirebaseFirestore.instance
        .collection("universities")
        .doc("university-of-warwick")
        .collection("spotlights")
        .where('society.ref', whereIn: societyRefs)
        .snapshots();

  }



  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
      stream: spotlightStream,
      builder: (context,snapshot) {
          if (snapshot.hasError || !snapshot.hasData) return CircularProgressIndicator();

          final spotlightData = snapshot.data!.docs.map((json) => Spotlight.fromJson(json.data() as Map<String,dynamic>)).toList();
          return SpotlightCard(spotlights: spotlightData, editable: false,);

          
          },
      
    );
  }
}
