import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TagSelectionScreen extends StatefulWidget {
  final DocumentReference userRef;
  TagSelectionScreen({required this.userRef});

  @override
  _TagSelectionScreenState createState() => _TagSelectionScreenState();
}

class _TagSelectionScreenState extends State<TagSelectionScreen> {
  List<String> selectedTags = [];
  List<String> allTags = [];

  @override
  void initState() {
    super.initState();
    fetchTags();
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
                Text("Step 4/4",
                  style: TextStyle(
                      color: Color(0xFFD9D9D9),
                      fontSize: 24,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.bold
                  ),),
                SizedBox(height: 12,),
                Text("Select your Interests",
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
                    spacing: 8,
                    runSpacing: 8,
                    children: allTags.map((soc) => clickableTagCard(soc)).toList()
                ),

              ],
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  _addTags();
                  Navigator.of(context).popUntil((route) => !Navigator.of(context).canPop());
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
  Future<void> _addTags() async{

    widget.userRef.update({
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

              ),
            ),
          ),
        ),
      ),
    );
  }

}
