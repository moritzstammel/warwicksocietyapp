import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:warwicksocietyapp/home/spotlight_details.dart';
import 'package:warwicksocietyapp/spotlight_creation/spotlight_creation_screen.dart';
import 'package:warwicksocietyapp/widgets/small_society_card.dart';
import 'dart:async';
import '../models/spotlight.dart';

class SpotlightCard extends StatefulWidget {
  final List<Spotlight> spotlights;
  final bool editable;
  final bool clickable;
  const SpotlightCard({required this.spotlights, required this.editable, this.clickable = true});

  @override
  State<SpotlightCard> createState() => _SpotlightCardState();
}

class _SpotlightCardState extends State<SpotlightCard> {
  late Timer _timer;
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: Random().nextInt(widget.spotlights.length));

    if(widget.spotlights.length <= 1) return;
    _timer = Timer.periodic(Duration(seconds: 8), (timer) {
      _pageController.animateToPage((_currentPage + 1), duration: Duration(milliseconds: 250), curve: Curves.easeOut);
    });
  }

  @override
  void dispose() {
    if(widget.spotlights.length > 1) _timer.cancel();
    super.dispose();
  }
  void resetTimer(){
    if(widget.spotlights.length <= 1) return;
    _timer.cancel();
    _timer = Timer.periodic(Duration(seconds: 8), (timer) {
      _pageController.animateToPage((_currentPage + 1), duration: Duration(milliseconds: 250), curve: Curves.easeOut);
    });
  }



  void openSpotlightInfo(Spotlight spotlight) {
    showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: "",
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: SpotlightDetails(spotlight: spotlight,),
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
    );
  }




  @override
  Widget build(BuildContext context) {
      return Container(
        width: double.infinity,
        height: 175,
        child: PageView.builder(
          onPageChanged: (index) {
            resetTimer();
            setState(() {
              _currentPage = index;
            });
          },
          scrollDirection: Axis.horizontal,
          controller: _pageController,
          itemBuilder: (context,index){
            final currentSpotlightIndex = index % widget.spotlights.length;
            return Container(

              child: GestureDetector(
                onTap: widget.clickable ? () {
                  if(widget.editable) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SpotlightCreationScreen(spotlight: widget.spotlights[currentSpotlightIndex],)),);
                    return;
                  }
                  openSpotlightInfo(widget.spotlights[currentSpotlightIndex]);


                } : null,
                child:
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding: EdgeInsets.only(right: 8,top: 8,left: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: widget.spotlights[currentSpotlightIndex].image ?? NetworkImage( widget.spotlights[currentSpotlightIndex].imageUrl),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.5),
                        BlendMode.darken,
                      ),
                    ),
                  ),
                  height: 150,
                  child: Stack(
                    children: [
                      Positioned(
                          top: 0,
                          right: 0,
                          child: widget.editable ? GestureDetector(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SpotlightCreationScreen(spotlight: widget.spotlights[currentSpotlightIndex],)),
                                );},
                              child: Icon(Icons.edit,color: Colors.white,size: 20,))
                              : SmallSocietyCard(society: widget.spotlights[currentSpotlightIndex].society,)
                      ),

                      Container(
                        width: 150,
                        child: Column(

                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 25,),
                            Text(

                              widget.spotlights[currentSpotlightIndex].title,
                              maxLines: 2,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: ElevatedButton(
                                onPressed: widget.clickable ? () {
                                  openSpotlightInfo( widget.spotlights[currentSpotlightIndex]);
                                }: (){},
                                child: Text(
                                  'More Info',
                                  style: TextStyle(color: Colors.black,fontFamily: 'Inter'),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  onPrimary: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  minimumSize: Size(100, 33),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Paging Indicator Dots (Hide if only one spotlight)
                      if (widget.spotlights.length > 1)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                widget.spotlights.length,
                                    (i) => Container(
                                  margin: EdgeInsets.symmetric(horizontal: 4),
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: i == currentSpotlightIndex
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),


              ),
            );
          },

        ),
      );
  }
}
