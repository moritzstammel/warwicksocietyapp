import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/authentication/FirestoreAuthentication.dart';
import 'package:warwicksocietyapp/models/firestore_user.dart';



class EditTags extends StatefulWidget {
  const EditTags({Key? key}) : super(key: key);

  @override
  State<EditTags> createState() => _EditTagsState();
}

class _EditTagsState extends State<EditTags> {
  final FirestoreUser user = FirestoreAuthentication.instance.firestoreUser!;
  late List<String> selectedTags;
  List<String> allTags = [];

  @override
  void initState() {
    super.initState();
    selectedTags = user.tags.keys.toList();
    fetchTags();
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
                    "Select your Interests",
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
                  SizedBox(height: 20),
                  Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: allTags.map((soc) => clickableTagCard(soc)).toList()
                  ),
                ],
              ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 35,
                      child: Center(
                        child: Text(
                          "${selectedTags.length} tags selected",
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
                    if(tagsWereChanged())
                    GestureDetector(
                      onTap: (){
                        saveTagSelection();
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
  bool tagsWereChanged() {
    var set1 = Set.from(selectedTags);
    var set2 = Set.from(user.tags.keys);
    return set1.length != set2.length || !set1.containsAll(set2);
  }

  Future<void> fetchTags() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('universities')
        .doc('university-of-warwick')
        .collection('tags')
        .get();

    setState(() {
      allTags =
          snapshot.docs.map((doc) => doc.id).toList();
    });
  }

  void toggleTag(String tag) {
    setState(() {
      if (selectedTags.contains(tag)) {
        selectedTags.remove(tag);
      } else {
        selectedTags.add(tag);
      }
    });
    print(selectedTags);
  }

  Future<void> saveTagSelection() async{
    final DocumentReference userRef = FirebaseFirestore.instance.doc("universities/university-of-warwick/users/${user.id}");
    userRef.update({
      "tags" : { for (var e in selectedTags) e : true }
    });
  }
  Widget clickableTagCard(String tag){
    bool isTapped =  selectedTags.contains(tag);

    return GestureDetector(
      onTap: () {
        setState(() {
          toggleTag(tag);
        });
      },
      child: IntrinsicWidth(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          height: 29,
          decoration: BoxDecoration(
            color: isTapped? Colors.black : Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(100),

          ),
          child: Center(
            child: Text(
              tag,
              style: TextStyle(
                fontFamily: 'Inter',
                color: isTapped? Colors.white : Color(0xFF333333),
                fontSize: 14,
                fontWeight: FontWeight.normal,
                decoration: TextDecoration.none

              ),
            ),
          ),
        ),
      ),
    );
  }
}
