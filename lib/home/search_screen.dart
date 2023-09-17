import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/authentication/FirestoreAuthentication.dart';
import 'package:warwicksocietyapp/widgets/small_society_card.dart';

import '../models/event.dart';
import '../models/society_info.dart';
import '../widgets/tag_card.dart';
import 'custom_search_bar.dart';
import '../widgets/event_card.dart';

class SearchScreen extends StatefulWidget {

  List<String>? selectedTags ;
  List<SocietyInfo>? selectedSocieties;
  SearchScreen({Key? key, this.selectedTags,this.selectedSocieties}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final user = FirestoreAuthentication.instance.firestoreUser!;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<String> allTags = [];
  final List<SocietyInfo> allSocieties = [];

  late List<String> selectedTags = (widget.selectedTags == null) ? [] : widget.selectedTags!;
  late List<SocietyInfo> selectedSocieties = (widget.selectedSocieties == null) ? [] : widget.selectedSocieties!;

  late bool onlyShowSelectedOptions = widget.selectedTags != null || widget.selectedSocieties != null;

  late Stream<QuerySnapshot> eventStream;

  @override
  void initState() {
    super.initState();

    loadAllSocieties();
    loadAllTags();

    eventStream = FirebaseFirestore.instance.collection("universities")
        .doc("university-of-warwick")
        .collection("events")
        .snapshots();

  }

  void loadAllSocieties() async {
    if(allSocieties.isNotEmpty) return;
    final snapshots = await FirebaseFirestore.instance.collection("universities")
        .doc("university-of-warwick")
        .collection("societies")
        .get();

    List<SocietyInfo> societies = snapshots.docs.map((snap) => SocietyInfo.fromJson(snap.data())).toList();
    setState(() {
      allSocieties.addAll(societies);
    });

  }
  void loadAllTags() async {
    if(allSocieties.isNotEmpty) return;
    final snapshots = await FirebaseFirestore.instance.collection("universities")
        .doc("university-of-warwick")
        .collection("tags")
        .get();

    List<String> tags = snapshots.docs.map((snap) => snap.id).toList();
    setState(() {
      allTags.addAll(tags);
    });

  }

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


    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: 
          SingleChildScrollView(
            controller: _scrollController,
          physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50,

                  margin: EdgeInsets.only(top: 20),
                    child: TextField(
                      onChanged: (String text){
                        setState(() {
                          onlyShowSelectedOptions = (text != "");
                        });
                      },
                      controller: _searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(bottom: 0),
                        hintText: 'Search...',
                        suffixIcon:
                        onlyShowSelectedOptions ?
                          GestureDetector(
                            onTap: () {setState(() {
                              _searchController.text="";
                              onlyShowSelectedOptions = false;
                              selectedTags = [];
                              selectedSocieties = [];
                            });},
                            child: Icon(Icons.close, color: Colors.black)) : null,
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
                if(_searchController.text == "" || selectedSocieties.isNotEmpty || selectedTags.isNotEmpty)
                SizedBox(height: 16,),
                if(!onlyShowSelectedOptions)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      children: allSocieties.map((society) => GestureDetector(
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
                    WrapSuper(


                      spacing: 8,
                      lineSpacing: 8,
                      children: allTags.map((tagName) => GestureDetector(
                          onTap: () => toggleTagSelection(tagName),
                          child: TagCard(name: tagName,textColor: selectedTags.contains(tagName)? Colors.white : const Color(0xFF333333), backgroundColor: selectedTags.contains(tagName)? Colors.black : const Color(0xFFF7F7F7),clickable: false,))).toList()

                    ),
                  ],
                ),
                if(onlyShowSelectedOptions)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                          selectedSocieties.map((society) => GestureDetector(
                              onTap: () => toggleSocietySelection(society),
                              child: SmallSocietyCard(society: society,textColor: Colors.white , backgroundColor: Colors.black,))).toList()
                          +
                          selectedTags.map((tagName) => GestureDetector(
                              onTap: () => toggleTagSelection(tagName),
                              child: TagCard(name: tagName,textColor: Colors.white, backgroundColor: Colors.black,clickable: false,))).toList()


                  ),

                SizedBox(height: 6,),
                Divider(),
                showSearchResult()



              ],
            ),
          ),
       
      ),
    );
  }


  Widget showSearchResult(){



    return StreamBuilder<QuerySnapshot>(
        stream: eventStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<Event> events = snapshot.data!.docs.map((json) => Event.fromJson(json.data() as Map<String,dynamic>,json.id)).toList();


          String searchString = _searchController.text;

          if (searchString.isNotEmpty) {
            events = events.where((event) =>
                event.title.toLowerCase().contains(searchString.toLowerCase()))
                .toList();
          }
          if(selectedSocieties.isNotEmpty) {
            events = events.where((event) =>
                selectedSocieties.contains(event.societyInfo))
                .toList();
          }
          if(selectedTags.isNotEmpty) {
            events = events.where((event) =>
                selectedTags.contains(event.tag))
                .toList();
          }


          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final event in events)
                EventCard(
                  event: event,
                  showRegistered: event.registeredUsers.containsKey(user.id) && event.registeredUsers[user.id]!,
                ),
            ],

          );
        }
    );
  }
}


