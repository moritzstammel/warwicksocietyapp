import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/feed/following_feed.dart';
import 'package:warwicksocietyapp/feed/testholder.dart';


class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final PageController _pageController = PageController();

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







  @override
  Widget build(BuildContext context) {

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


              FollowingFeed(),
              PageView.builder(
                scrollDirection: Axis.vertical,
                itemBuilder: (context,index){
                  return FeedContainer("https://firebasestorage.googleapis.com/v0/b/warwick-society-app.appspot.com/o/feed2.jpeg?alt=media","test");
                },
              )

            ]
          ),
          FeedSelectionBar(),



        ]
      ),


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
