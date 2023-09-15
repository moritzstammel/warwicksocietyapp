import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:warwicksocietyapp/authentication/tag_selection_screen.dart';
import 'package:warwicksocietyapp/models/society_info.dart';

import '../models/society.dart';

class SocietySelectionScreen extends StatefulWidget {
  final DocumentReference userRef;
  SocietySelectionScreen({required this.userRef});

  @override
  _SocietySelectionScreenState createState() => _SocietySelectionScreenState();
}

class _SocietySelectionScreenState extends State<SocietySelectionScreen> {
  List<SocietyInfo> selectedSocieties = [];
  List<SocietyInfo> allSocieties = [];

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
          snapshot.docs.map((doc) => SocietyInfo.fromJson(doc.data() as Map<String, dynamic>)).toList();
    });
  }

  void toggleSociety(SocietyInfo society) {
    setState(() {
      if (selectedSocieties.contains(society)) {
        selectedSocieties.remove(society);
      } else {
        selectedSocieties.add(society);
      }
    });
    print(selectedSocieties);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(top: 28),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Step 3/4",
                style: TextStyle(
                  color: Color(0xFFD9D9D9),
                  fontSize: 24,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.bold
                ),),
                SizedBox(height: 12,),
                Text("Select your Societies",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.bold
                  ),),
                SizedBox(height: 8,),
                Text("You can always change your mind later",
                  style: TextStyle(
                      color: Color(0xFF888888),
                      fontSize: 16,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500
                  ),),
                SizedBox(height: 40,),
                Wrap(
                    runSpacing: 16,
                    children: allSocieties.map((soc) => ClickableSocietyCard(soc)).toList()
                ),

              ],
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  _followSocieties();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TagSelectionScreen(userRef: widget.userRef),
                    ),
                  );
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
      ),
    );
  }
  Future<void> _followSocieties() async{


    widget.userRef.update({
      "followed_societies" : selectedSocieties.map((e) => e.toJson()).toList()
    });
  }
  Widget ClickableSocietyCard(SocietyInfo societyInfo){
    bool isTapped=  selectedSocieties.contains(societyInfo);
    return GestureDetector(
      onTap: () {
        setState(() {
          toggleSociety(societyInfo);
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 14),
        width: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width:  64,
                  height: 64 ,
                  child: Center(
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 100),
                      width: (isTapped) ? 56 : 64,
                      height: (isTapped) ? 56 : 64 ,
                      foregroundDecoration:(isTapped) ? BoxDecoration(
                        color: Colors.grey,
                        backgroundBlendMode: BlendMode.saturation,
                      ) : null,
                      decoration: BoxDecoration(

                        borderRadius: BorderRadius.circular(16), // Rounded corners
                        image: DecorationImage(
                          image: NetworkImage(societyInfo.logoUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                if (isTapped)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 8), // Spacing
            Text(
              societyInfo.name,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: isTapped ? Colors.grey : Colors.black, // Change color as needed
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

}
