import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/home/spotlight_details.dart';
import 'package:warwicksocietyapp/widgets/small_society_card.dart';
import 'dart:async';

import '../models/society_info.dart';
import '../models/spotlight.dart';

class SpotlightCard extends StatefulWidget {
  final List<Spotlight> spotlights;
  final bool editable;

  const SpotlightCard({required this.spotlights, required this.editable});

  @override
  State<SpotlightCard> createState() => _SpotlightCardState();
}

class _SpotlightCardState extends State<SpotlightCard> {
  int _currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    if(widget.spotlights.length < 2) return;
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.spotlights.length;
      });
    });
  }

  @override
  void dispose() {
    if(widget.spotlights.length > 1) _timer.cancel();
    
    super.dispose();
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
    if (widget.spotlights.isEmpty){
      widget.spotlights.add(Spotlight(title: "Freshers\nEvents", text: "cool Text",  society: SocietyInfo(
          name: "Warwick Piano Society",
          logoUrl: "test.de",
          ref:FirebaseFirestore.instance.doc("/universities/university-of-warwick/societies/S3lJHuxEAzhBlIx1EVED")
      ), image: NetworkImage("https://warwick.ac.uk/about/campus/oculus-3-2.jpg"),links: []));
    }
    
    
    
      return Container(
        width: double.infinity,
        child: GestureDetector(
          onTap: () {
            setState(() {
              if(widget.spotlights.length>1) {
                _currentIndex = (_currentIndex + 1) % widget.spotlights.length;
              }
              if(widget.spotlights.length==1){
                openSpotlightInfo(widget.spotlights.first);
              }
            });
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: EdgeInsets.only(right: 8,top: 8,left: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: widget.spotlights[_currentIndex].image,
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
                  child: SmallSocietyCard(society: widget.spotlights[_currentIndex].society,)
                ),

                Container(
                  width: 150,
                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 25,),
                      Text(

                        widget.spotlights[_currentIndex].title,
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
                          onPressed: () {
                            openSpotlightInfo( widget.spotlights[_currentIndex]);
                          },
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
                              (index) => Container(
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentIndex == index
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
  }
}
