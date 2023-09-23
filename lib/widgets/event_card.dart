import 'package:cached_network_image/cached_network_image.dart';
import 'package:warwicksocietyapp/home/event_details_screen.dart';
import 'package:warwicksocietyapp/models/firestore_user.dart';

import '../event_creation/event_creation_screen.dart';
import '../models/event.dart';

import 'package:flutter/material.dart';


class EventCard extends StatelessWidget {
  final Event event;
  final bool showRegistered;
  final bool isLive = false;
  final bool isEditable;


  const EventCard({required this.event, this.showRegistered = true,this.isEditable = false});

  static const Map<int, String> _weekdayShortMap = {
    1: 'Mon',
    2: 'Tue',
    3: 'Wed',
    4: 'Thu',
    5: 'Fri',
    6: 'Sat',
    7: 'Sun',
  };

  PageRouteBuilder _customPageRouteBuilder(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Starting offset of the incoming screen
        const end = Offset.zero; // Ending offset of the incoming screen
        const curve = Curves.easeInOut; // Transition curve

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          _customPageRouteBuilder(EventDetailsScreen(event: event)),
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: 8),
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isLive) // Check if isLive is true
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: Color(0xFF00DD00),
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  ),

              ),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 100,
                height: 100,
                child: CachedNetworkImage(
                    imageUrl: event.societyInfo.logoUrl,fit: BoxFit.cover,
                    placeholder: (context, url) => Container(width: 100,height: 100,color: Color(0xFFF7F7F7),),
                    errorWidget: (context, url, error) => const Center(child: Icon(Icons.error),))
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (showRegistered)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Color(0xFFDDFFDD),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            'Registered',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF00DD00),
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (showRegistered) SizedBox(width: 8),
                      ImageIcon(
                        AssetImage('assets/icons/events/location.png'),
                        size: 14,
                      ),
                      SizedBox(width: 4),
                      Text(
                        event.location,

                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Inter',
                          color: Color(0xFF333333),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                event.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              if (event.points > 0)
                                SizedBox(width: 8),
                              if (event.points > 0)
                                Container(
                                  height: 13,
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  alignment: Alignment.center,
                                  child: Center(child: Text(
                                    " ${event.points.toString()} points",
                                    style: TextStyle(
                                      fontSize: 8,
                                      color: Colors.white,
                                      fontFamily: 'Inter',
                                    ),
                                  )),
                                ),
                            ],
                          ),
                          SizedBox(height: 8,),
                          Row(
                            children: [
                              ImageIcon(
                                AssetImage('assets/icons/events/clock.png'),
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                '${_weekdayShortMap[event.startTime.weekday]}, ${event.startTime.hour.toString().padLeft(2, '0')}:${event.startTime.minute.toString().padLeft(2, '0')}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                  color: Color(0xFF333333),
                                ),
                              ),
                              SizedBox(width: 4),
                              ImageIcon(
                                AssetImage('assets/icons/events/calendar.png'),
                                size: 16,
                              ),

                              SizedBox(width: 4),
                              Text(
                                '${event.startTime.day.toString().padLeft(2, '0')}.${event.startTime.month.toString().padLeft(2, '0')}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                  color: Color(0xFF333333),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(width: 8),
                      (isEditable) ?
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EventCreationScreen(event: event,)),
                          );
                        },
                        child: ImageIcon(
                          AssetImage('assets/icons/edit-black.png'),
                          size: 24,
                        ),
                      )
                      :
                      ImageIcon(
                        AssetImage('assets/icons/events/chevron-right.png'),
                        size: 24,
                      )

                      ,
                    ],
                  ),


                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
