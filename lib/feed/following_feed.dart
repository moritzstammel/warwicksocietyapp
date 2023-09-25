import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/feed/event_feed_card.dart';
import 'package:warwicksocietyapp/models/event.dart';


class FollowingFeed extends StatefulWidget {
  const FollowingFeed({Key? key}) : super(key: key);

  @override
  State<FollowingFeed> createState() => _FollowingFeedState();
}

class _FollowingFeedState extends State<FollowingFeed> with AutomaticKeepAliveClientMixin,WidgetsBindingObserver  {
  @override
  bool get wantKeepAlive => true;


  int loading = 3;
  DocumentSnapshot? lastDocument;
  List<Event> events = [];
  int currentPage = 0;
  final _pageController = PageController();


  void scrollToNextPage(){

    if(_pageController.page == null || _pageController.page!.round() >= events.length) return;
    final int currentPage = _pageController.page!.round();
    _pageController.animateToPage(currentPage +1, duration: Duration(milliseconds: 350), curve: Curves.easeOut);
  }

  Future<void> fetchNewEvents() async{
    print("Reloading current length :${events.length}");

    CollectionReference eventsCollection =
    FirebaseFirestore.instance
        .collection('universities/university-of-warwick/events');


    QuerySnapshot result = (lastDocument == null) ?
    await eventsCollection
        .limit(loading)
        .orderBy("start_time")
        .get()
        :
    await eventsCollection
        .limit(loading)
        .orderBy("start_time")
        .startAfterDocument(lastDocument!)
        .get();


    if(result.docs.isEmpty) return;
    lastDocument = result.docs.last;

    setState(() {
      events.addAll(result.docs.map((doc) => Event.fromJson(doc.data() as Map<String,dynamic>,doc.id)));
    });





  }


  @override
  void initState() {
    super.initState();
    fetchNewEvents();
  }

  @override
  Widget build(BuildContext context) {

    if(events.isEmpty){
      return Center(child: Text("No events"),);
    }

    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemCount: events.length,
      itemBuilder: (context, index) {
        print(index);
        print(events.length);
        print(events);
        final event = events[index];
        if(index + 1 == events.length) {
          print("reloading");
          fetchNewEvents();
        }
        return EventFeedCard(event: event,scrollToNextPage: scrollToNextPage,);
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
