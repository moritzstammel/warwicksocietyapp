import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:warwicksocietyapp/models/society_info.dart';

import '../models/society.dart';

class SocietySelectionScreen extends StatefulWidget {
  final DocumentReference userRef;
  SocietySelectionScreen({required this.userRef});

  @override
  _SocietySelectionScreenState createState() => _SocietySelectionScreenState();
}

class _SocietySelectionScreenState extends State<SocietySelectionScreen> {
  List<Society> selectedSocieties = [];
  List<Society> allSocieties = [];

  @override
  void initState() {
    super.initState();
    fetchSocieties();
  }

  Future<void> fetchSocieties() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('universities')
        .doc('university-of-warwick')
        .collection('societies')
        .get();

    setState(() {
      allSocieties =
          snapshot.docs.map((doc) => Society.fromJson(doc.data() as Map<String, dynamic>, doc.id)).toList();
    });
  }

  void toggleSociety(Society society) {
    setState(() {
      if (selectedSocieties.contains(society)) {
        selectedSocieties.remove(society);
      } else {
        selectedSocieties.add(society);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Select the Societies you are interested in',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Inter',
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: allSocieties.length,
              itemBuilder: (context, index) {
                Society society = allSocieties[index];
                bool isSelected = selectedSocieties.contains(society);

                return GestureDetector(
                  onTap: () {
                    toggleSociety(society);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                              image: NetworkImage(society.logoUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          society.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Inter',
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                _followSocieties();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                minimumSize: Size(350, 50),
                maximumSize: Size(350, 50),
              ),
              child: Text(
                'Continue',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Future<void> _followSocieties() async{
    List<SocietyInfo> followedSocieties = selectedSocieties.map((society) => society.toSocietyInfo()).toList();

    widget.userRef.update({
      "followed_societies" : followedSocieties.map((e) => e.toJson()).toList()
    });
  }
}
