import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/feed/sign_up_button.dart';
import 'package:warwicksocietyapp/models/event.dart';
import 'package:warwicksocietyapp/widgets/tag_card.dart';

class EventFeedCard extends StatelessWidget {
  final Event event;
  const EventFeedCard({Key? key,required this.event}) : super(key: key);

  static const Map<int, String> _weekdayShortMap = {
    1: 'Mon',
    2: 'Tue',
    3: 'Wed',
    4: 'Thu',
    5: 'Fri',
    6: 'Sat',
    7: 'Sun',
  };

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
            Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(event.images[0]),
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
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TagCard(name: event.tag,backgroundColor: Colors.transparent,textColor: Colors.white,borderColor: Colors.white,),
                SizedBox(height: 8,),
                displaySociety(),
                SizedBox(height: 8,),

                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(event.title,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontFamily: "Inter"
                            ),),
                          SizedBox(height: 8,),
                          Container(
                            width: 260,
                            child: Text(event.description,
                              maxLines: 2,
                              style: TextStyle(

                                fontSize: 14,
                                color: Color(0xFFFFFFFF).withOpacity(0.75),
                                fontFamily: "Inter",

                              ),),
                          ),
                          SizedBox(height: 8,),
                          displayCoreDates(),
                          SizedBox(height: 8,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                child: Text(
                                  "More info",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      decoration: TextDecoration.underline,
                                      decorationStyle: TextDecorationStyle.solid,
                                      fontFamily: "Inter"
                                  ),
                                ),
                              ),
                              SignUpButton()
                            ],
                          )
                        ],
                      ),
                    ),



              ],
            ),
          )



        ]);
  }
  Widget displayCoreDates(){
    return Row(
      children: [
        Icon(
          Icons.location_on,
          size: 16,
          color: Colors.white,
        ),
        SizedBox(width: 2),
        Text(
          event.location,
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'Inter',
            color:  Colors.white,
          ),
        ),
        SizedBox(width: 2),
        Icon(
          Icons.access_time,
          size: 16,
          color:  Colors.white,
        ),
        SizedBox(width: 2),
        Text(
          '${_weekdayShortMap[event.startTime.weekday]}, ${event.startTime.hour.toString().padLeft(2, '0')}:${event.startTime.minute.toString().padLeft(2, '0')}',
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'Inter',
            color: Colors.white,
          ),
        ),
        SizedBox(width: 2),
        Icon(
          Icons.calendar_today,
          size: 16,
          color: Colors.white,
        ),
        SizedBox(width: 2),
        Text(
          '${event.startTime.day.toString().padLeft(2, '0')}.${event.startTime.month.toString().padLeft(2, '0')}',
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'Inter',
            color:  Colors.white,
          ),
        ),
      ],
    );
  }


  Widget displaySociety(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipOval(
          child: Container(
            color: Colors.white,
            child: Image.network(
              event.societyInfo.logoUrl, // Replace with the network image URL
              width: 48,
              height: 48,
              fit: BoxFit.contain,
            ),
          ),

        ),
        SizedBox(width: 12,),

           Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: Text(
              event.societyInfo.name,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                  fontFamily: "Inter"
              ),
            ),
          ),
        SizedBox(width: 4,),
        Icon(
          Icons.verified,
          size: 16,
          color:  Colors.white,
        ),


      ],
    );
  }


}


