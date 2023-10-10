import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/authentication/FirestoreAuthentication.dart';
import 'package:warwicksocietyapp/firestore_helper.dart';
import 'package:warwicksocietyapp/models/firestore_user.dart';
import 'package:warwicksocietyapp/models/society_info.dart';



class EditSocieties extends StatefulWidget {
  

  @override
  State<EditSocieties> createState() => _EditSocietiesState();
}

class _EditSocietiesState extends State<EditSocieties> {
  final FirestoreUser user = FirestoreAuthentication.instance.firestoreUser!;
  late List<SocietyInfo> selectedSocieties;
  List<SocietyInfo> allSocieties = [];

  @override
  void initState() {
    super.initState();
    selectedSocieties = List<SocietyInfo>.from(user.followedSocieties.values);
    fetchSocieties();
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
                      //SmallSocietyCard(society: spotlight.society,backgroundColor: Colors.black,textColor: Colors.white,),
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
                    "Select your Societies",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.black,
                        fontFamily: "Inter",
                        decoration: TextDecoration.none
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: 280,
                    child: Text(
                      "You can always change your mind later",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.none
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                   Container(
                     height: 370,
                     child: ListView(
                       padding: EdgeInsets.all(0),
                         shrinkWrap: true,
                         children: [
                         Wrap(
                                runSpacing: 16,
                                spacing: 12,
                                children: allSocieties.map((soc) => ClickableSocietyCard(soc)).toList()
                            ),
                       ],
                     ),
                   )
                ],
              ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 35,
                      child: Center(
                        child: Text(
                          (selectedSocieties.length <= 10) ? "${selectedSocieties.length} societies selected" : "Select up to 10 societies.",
                          style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF888888),
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.none
                          ),
                        ),
                      ),
                    ),
                    if(societiesWereChanged() && selectedSocieties.length <= 10)
                    GestureDetector(
                      onTap: (){
                        _followSocieties();
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 107,
                        height: 35,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                          child: Text(
                            "Save changes",
                            style: TextStyle(
                                fontFamily: "Inter",
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.none
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
  bool societiesWereChanged() {
    var set1 = Set.from(selectedSocieties);
    var set2 = Set.from(user.followedSocieties.values);
    return set1.length != set2.length || !set1.containsAll(set2);
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
  }

  Future<void> _followSocieties() async{
    List<SocietyInfo> societiesToUnfollow = user.followedSocieties.values.where((society) => !selectedSocieties.contains(society)).toList();
    List<SocietyInfo> societiesToFollow = selectedSocieties.where((society) => !user.followedSocieties.values.contains(society)).toList();

    for(final society in societiesToUnfollow){
      FirestoreHelper.instance.unfollowSociety(society);
    }
    for(final society in societiesToFollow){
      FirestoreHelper.instance.followSociety(society);
    }
  }
  Widget ClickableSocietyCard(SocietyInfo societyInfo){
    bool isTapped=  !selectedSocieties.contains(societyInfo);
    return GestureDetector(
      onTap: () {
        setState(() {
          toggleSociety(societyInfo);
        });
      },
      child: Container(
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
                      width: (isTapped) ? 52 : 64,
                      height: (isTapped) ? 52 : 64 ,
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

              ],
            ),
            SizedBox(height: 8), // Spacing
            Text(
              societyInfo.name,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.none,
                color: isTapped ? Colors.grey : Colors.black,
                fontFamily: "Inter"
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
