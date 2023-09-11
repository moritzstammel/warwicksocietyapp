import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:warwicksocietyapp/authentication/FirestoreAuthentication.dart';
import 'package:warwicksocietyapp/feed/testholder.dart';
import 'package:warwicksocietyapp/models/event.dart';

import '../models/firestore_user.dart';

class FollowingFeed extends StatefulWidget {
  const FollowingFeed({Key? key}) : super(key: key);

  @override
  State<FollowingFeed> createState() => _FollowingFeedState();
}

class _FollowingFeedState extends State<FollowingFeed> with AutomaticKeepAliveClientMixin,WidgetsBindingObserver  {
  @override
  bool get wantKeepAlive => true;

  final PageController _followingController = PageController();
  int loading = 3;
  DocumentSnapshot? lastDocument;
  List<TestHolder> events = [];
  Set<String> seenEvents = {};
  int currentPage = 0;



  Stream<FirestoreUser> getUser(){
    return FirebaseFirestore.instance.doc("universities/university-of-warwick/users/${FirestoreAuthentication.instance.firestoreUser!.id}").snapshots().map((e) => FirestoreUser.fromJson(e.data()!,e.id));
  }
  Stream<List<TestHolder>> getEvents(){
    return FirebaseFirestore.instance.collection("universities/university-of-warwick/testevents")
        .orderBy("title")
        .limit(30)
        .snapshots()

        .map((snap) {
          return snap.docs.map((doc) => TestHolder.fromJson(doc.data())).toList();});

  }
  Stream<List<TestHolder>> getUnseenEvents(){
    return Rx.combineLatest2(
        getUser(),
        getEvents(),
            (FirestoreUser user, List<TestHolder> events) =>
                events.where((event) => !user.eventsSeen.contains(event.title)).toList()
    );
  }

  Future<void> fetchNewEvents() async{

    return;

    print(events);
    if (currentPage +1  < events.length) return;

    print("Reloading current length :${events.length}");

    CollectionReference eventsCollection =
    FirebaseFirestore.instance
        .collection('universities/university-of-warwick/testevents');

    QuerySnapshot result = (lastDocument == null) ?
    await eventsCollection
        .limit(loading)
        .orderBy("title")
        // Adjust the limit based on the current page
        .get()
        :
    await eventsCollection

      .limit(loading)
        .orderBy("title")
        .startAfterDocument(lastDocument!)
        .get();

    lastDocument = result.docs.last;
    events.addAll(result.docs.map((doc) => TestHolder.fromJson(doc.data() as Map<String,dynamic>)));

    print(events);



  }
  void markEventsAsSeen(List<String> events) {
    // Replace 'eventTitle' with the actual event title you want to add.
    String userId = FirestoreAuthentication.instance.firestoreUser!.id;

    // Use FieldValue.arrayUnion to add an item to the 'events_seen' array in Firestore.
    FirebaseFirestore.instance
        .doc("universities/university-of-warwick/users/$userId")
        .update({
      "events_seen": FieldValue.arrayUnion(events)
    });
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      // The app is being paused (user is leaving the app)
      markEventsAsSeen(seenEvents.toList());
    }
  }


  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
            stream: getUnseenEvents(),
            builder: (BuildContext context, AsyncSnapshot<List<TestHolder>> snapshot) {
              if(!snapshot.hasData) return CircularProgressIndicator();
              events = snapshot.data!;
              seenEvents.add(events[0].title);
              print(seenEvents);
              print(events.length);
              if (events.isEmpty) return CircularProgressIndicator();
              return PageView.builder(
                onPageChanged: (int index){
                  seenEvents.add(events[index].title);
                  print(seenEvents);} ,
                controller: _followingController,
                scrollDirection: Axis.vertical,

                itemBuilder: (context, index) {

                  final event = events[index];
                  //if(events.length == index + 1){
                  //  fetchNewEvents();}
                  return FeedContainer(event.imageUrl,event.title);
                },
              );

            },

    );
  }


  Widget FeedContainer(String imageUrl,String title){
    return Stack(
        children: [Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Container(
                height: 300, // Adjust the height of the gradient as needed
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(1), // Adjust the opacity as needed
                    ],
                  ),


                ),
              ),

              // Add more widgets below for displaying content
            ],
          ),
        ),
          Center(child: Container(
            height: 200,
            width: 200,
            color: Colors.white,
            child: Text(title),
          ),)


        ]);
  }

}
