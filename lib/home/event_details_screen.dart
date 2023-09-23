import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:warwicksocietyapp/authentication/FirestoreAuthentication.dart';
import 'package:warwicksocietyapp/authentication/SocietyAuthentication.dart';
import 'package:warwicksocietyapp/firebase_helper.dart';
import 'package:warwicksocietyapp/home/search_screen.dart';
import 'package:warwicksocietyapp/notification_helper.dart';
import '../models/event.dart';
import '../models/firestore_user.dart';


class EventDetailsScreen extends StatefulWidget {
  final Event event;


  EventDetailsScreen({required this.event});

  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  bool userIsRegistered = false;
  final FirestoreUser user = FirestoreAuthentication.instance.firestoreUser!;
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
  void initState() {
    super.initState();
    checkRegistrationStatus();
  }

  void checkRegistrationStatus() {
    setState(() {
      userIsRegistered = widget.event.registeredUsers.containsKey(user.id) && widget.event.registeredUsers[user.id]!.active == true;
    });
  }

  void toggleRegistration() {
    setState(() {
      userIsRegistered = !userIsRegistered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body:
           Column(
             crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                widget.event.images[0],
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.event.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  ImageIcon(
                    AssetImage('assets/icons/events/location.png'),
                    size: 20,
                  ),
                  Spacer(),
                  Text(widget.event.location , style: TextStyle(color: Color(0xFF333333),fontSize: 12),),
                  Spacer(),
                  ImageIcon(
                    AssetImage('assets/icons/events/calendar.png'),
                    size: 20,
                  ),
                  Spacer(),
                  Text(formatDateTime(widget.event.startTime), style: TextStyle(color: Color(0xFF333333),fontSize: 12),),
                  Spacer(),
                  ImageIcon(
                    AssetImage('assets/icons/events/clock.png'),
                    size: 20,
                  ),
                  Spacer(),
                  Text(formatDateTimeRange(widget.event.startTime,widget.event.endTime), style: TextStyle(color: Color(0xFF333333),fontSize: 12),),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.event.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF333333)
                ),
              ),
            ),


              Expanded(
              child: Align(
              alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white, // Add the background color you want
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchScreen(selectedSocieties: [widget.event.societyInfo],),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                widget.event.societyInfo.logoUrl,
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                                
                              ),
                              
                            ),
                            SizedBox(width: 16),
                            Text(
                              widget.event.societyInfo.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      if(!SocietyAuthentication.instance.isSociety && widget.event.endTime.isAfter(DateTime.now()))
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        child: ElevatedButton(
                          onPressed: () async {
                            if(userIsRegistered){
                              FirestoreHelper.instance.signOutForEvent(widget.event);
                            }
                            else{
                              FirestoreHelper.instance.signUpForEvent(widget.event);
                            }


                            toggleRegistration();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            minimumSize: Size(350, 50),
                            maximumSize: Size(350, 50),
                          ),
                          child: Text(
                            userIsRegistered ? 'Sign Out' : 'Sign Up',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                  ],
                ),
              ),
            ),
              ),
  ]),

    );
  }
  String formatDateTime(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year.toString();
    return '$day.$month.$year';
  }


  String formatDateTimeRange(DateTime startTime, DateTime endTime) {
    final startDay = _weekdayShortMap[startTime.weekday];
    final startTimeStr = '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
    final endTimeStr = '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
    return '$startDay $startTimeStr - $endTimeStr';
  }





}
