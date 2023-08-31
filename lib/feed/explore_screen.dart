import 'package:flutter/material.dart';


class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {

  bool isSelected = true;

  void toggleFollowing() {
    setState(() {
      isSelected = !isSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
          scrollDirection: Axis.vertical,
            itemBuilder: (context,index){
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('https://www.warwick-castle.com/media/lhoddsjw/courtyard.jpg'),
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
              );
            },



                ),
          FeedSelectionBar(),



        ]
      ),


    );
  }


  Widget FeedSelectionBar(){
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
                  duration: Duration(milliseconds: 100),
                  left: !isSelected ? 125 : 2,
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

                        duration: Duration(milliseconds: 100),

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
                              color: isSelected ? Colors.white : Colors.black,
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
                        duration: Duration(milliseconds: 100),
                        child: Center(
                          child: Text(
                            'All Societies',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              color: !isSelected ? Colors.white : Colors.black,
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
