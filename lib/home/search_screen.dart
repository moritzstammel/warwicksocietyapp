import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/authentication/FirestoreAuthentication.dart';
import 'package:warwicksocietyapp/widgets/small_society_card.dart';

import '../models/society_info.dart';
import '../widgets/tag_card.dart';
import 'custom_search_bar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final user = FirestoreAuthentication.instance.firestoreUser!;
  List<String> selectedTags = [];
  List<SocietyInfo> selectedSocieties = [];

  void toggleTagSelection(String tagName) {
    setState(() {
      if (selectedTags.contains(tagName)) {
        selectedTags.remove(tagName);
      } else {
        selectedTags.add(tagName);
      }
    });
  }
  void toggleSocietySelection(SocietyInfo society) {
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
    final userTags = user.tags.keys.toList();
    final userSocieties = user.followedSocieties;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(

              margin: EdgeInsets.only(top: 20),
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Enter your search query...',
                  prefixIcon: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(Icons.arrow_back, color: Colors.black)),
                  filled: true,
                  fillColor: Color(0xFFF7F7F7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16,),
            Text(
              'FILTER BY SOCIETY',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 12,),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: userSocieties.map((society) => GestureDetector(
                  onTap: () => toggleSocietySelection(society),
                  child: SmallSocietyCard(society: society,textColor: selectedSocieties.contains(society)? Colors.white : const Color(0xFF333333), backgroundColor: selectedSocieties.contains(society)? Colors.black : const Color(0xFFF7F7F7),))).toList(),
            ),
            SizedBox(height: 16,),
            Text(
              'FILTER BY TAG',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 12,),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: userTags.map((tagName) => GestureDetector(
                  onTap: () => toggleTagSelection(tagName),
                  child: TagCard(name: tagName,textColor: selectedTags.contains(tagName)? Colors.white : const Color(0xFF333333), backgroundColor: selectedTags.contains(tagName)? Colors.black : const Color(0xFFF7F7F7),))).toList(),
            ),
            Divider()



          ],
        ),
      ),
    );
  }
}


