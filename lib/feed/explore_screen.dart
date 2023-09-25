import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/authentication/FirestoreAuthentication.dart';
import 'package:warwicksocietyapp/feed/feed_container.dart';
import 'package:warwicksocietyapp/models/firestore_user.dart';

import '../models/event.dart';


class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final PageController _pageController = PageController();
  List<Event> allEvents = [];
  bool onFirstFeed = true;


  void toggleFollowing() {
    setState(() {
      onFirstFeed = !onFirstFeed;
    });

    _pageController.animateToPage(
    onFirstFeed ? 0 : 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );


  }

  void fetchEvents() async{
    List<Event> fetchedEvents = await FirebaseFirestore.instance
        .collection("universities")
        .doc("university-of-warwick")
        .collection("events")
        .where('start_time', isGreaterThan: Timestamp.fromDate(DateTime.now()))
        .get().then((value) => value.docs.map((element) => Event.fromJson(element.data(),element.id)).toList());

    setState(() {
      allEvents = fetchedEvents;
    });

  }


  @override
  void initState() {
    super.initState();
    fetchEvents();

  }

  @override
  Widget build(BuildContext context) {

    FirestoreUser user = FirestoreAuthentication.instance.firestoreUser!;
    allEvents = allEvents.where((event) => !event.registeredUsers.containsKey(user.id) || event.registeredUsers[user.id]!.active==false).toList();

    List<Event> nonSocietyEvents = allEvents.where((event) => !user.followedSocieties.containsKey(event.societyInfo.ref.id)).toList();


    List<Event> nonSocietyEventsWithTag = nonSocietyEvents.where((event) => user.tags.keys.contains(event.tag)).toList();
    List<Event> nonSocietyEventsWithoutTag = nonSocietyEvents.where((event) => !user.tags.keys.contains(event.tag)).toList();

    List<Event> societyFeed = allEvents.where((event) => user.followedSocieties.containsKey(event.societyInfo.ref.id)).toList();
    List<Event> allSocietiesFeed = nonSocietyEventsWithTag + nonSocietyEventsWithoutTag;
    return Scaffold(
      body: Stack(
        children: [
          PageView(
                controller: _pageController,
                onPageChanged: (index){
                  setState(() {
                    onFirstFeed = index.isEven;
                  });
                },

                scrollDirection: Axis.horizontal,
                children: [
                  FeedContainer(events: societyFeed),
                  FeedContainer(events: allSocietiesFeed)
                ]


          ),
          FeedSelectionBar(),



        ]
      ),


    );
  }


  Widget FeedSelectionBar(){
    int durationInMilliseconds = 170;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 50),
          width: 250,
          height: 35,

          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(100)),
            color: Colors.white,
          ),
          child:Stack(
              children: [
                AnimatedPositioned(

                  duration: Duration(milliseconds: durationInMilliseconds),
                  curve: Curves.easeOut,
                  left: !onFirstFeed ? 125 : 2,
                  top: 2,

                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      color: Colors.black,
                    ),
                    width: 123,
                    height: 31,

                  ),
                ),


                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: toggleFollowing,
                      child: AnimatedContainer(

                        duration: Duration(milliseconds: durationInMilliseconds),

                        width: 123,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(

                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                        child: Center(
                          child: Text(
                            'Following',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              color: onFirstFeed ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: toggleFollowing,
                      child: AnimatedContainer(
                        height: 31,
                        width: 123,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(

                          borderRadius: BorderRadius.all(Radius.circular(100)),

                        ),
                        duration: Duration(milliseconds: durationInMilliseconds),
                        child: Center(
                          child: Text(
                            'All Societies',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              color: !onFirstFeed ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

              ]),

        ),
      ],
    );
  }
}
