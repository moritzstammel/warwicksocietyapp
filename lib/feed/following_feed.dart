import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/feed/testholder.dart';

class FollowingFeed extends StatefulWidget {
  const FollowingFeed({Key? key}) : super(key: key);

  @override
  State<FollowingFeed> createState() => _FollowingFeedState();
}

class _FollowingFeedState extends State<FollowingFeed> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final PageController _followingController = PageController();
  int loading = 3;
  DocumentSnapshot? lastDocument;
  List<TestHolder> events = [];
  int currentPage = 0;

  Future<void> fetchNewEvents() async{
    print("Reloading current length :${events.length}");
    CollectionReference eventsCollection =
    FirebaseFirestore.instance
        .collection('universities/university-of-warwick/testevents');

    QuerySnapshot result = (lastDocument == null) ?
    await eventsCollection
        .limit(loading)
        .orderBy("title") // Adjust the limit based on the current page
        .get()
        :
    await eventsCollection
        .limit(loading)
        .orderBy("title")
        .startAfterDocument(lastDocument!)
        .get();
    setState(() {
      lastDocument = result.docs.last;
      events.addAll(result.docs.map((doc) => TestHolder.fromJson(doc.data() as Map<String,dynamic>)));
    });


  }

  @override
  void initState() {
    super.initState();
    fetchNewEvents();


  }



  @override
  Widget build(BuildContext context) {
    return PageView.builder(
          controller: _followingController,
          scrollDirection: Axis.vertical,

          itemBuilder: (context, index) {
            currentPage = index;
            final event = events[index];
            if(events.length == index + 1){
              fetchNewEvents();}
            return FeedContainer(event.imageUrl,event.title);
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
