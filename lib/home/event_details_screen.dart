import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:warwicksocietyapp/authentication/FirestoreAuthentication.dart';
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
      userIsRegistered = widget.event.registeredUsers.containsKey(user.id) && widget.event.registeredUsers[user.id] == true;
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

      body:
           Column(
             crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                "https://cdn.pixabay.com/photo/2016/11/23/15/48/audience-1853662_640.jpg",
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
                  Icon(Icons.location_on,color:Color(0xFF333333) ,),
                  Spacer(),
                  Text(widget.event.location , style: TextStyle(color: Color(0xFF333333),fontSize: 12),),
                  Spacer(),
                  Icon(Icons.calendar_today,color:Color(0xFF333333) ,),
                  Spacer(),
                  Text(formatDateTime(widget.event.startTime), style: TextStyle(color: Color(0xFF333333),fontSize: 12),),
                  Spacer(),
                  Icon(Icons.access_time,color:Color(0xFF333333) ,),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            widget.event.societyInfo.logoUrl,
                            width: 40,
                            height: 40,
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
                      SizedBox(height: 16),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        child: ElevatedButton(
                          onPressed: () async {
                            DocumentReference eventRef = FirebaseFirestore.instance.doc("universities/university-of-warwick/events/${widget.event.id}");
                            DocumentReference chatRef = FirebaseFirestore.instance.doc("universities/university-of-warwick/chats/${widget.event.id}");

                            Map<String,dynamic> updatedEventUsers = {
                              'registered_users.${user.id}': !userIsRegistered
                            };
                            Map<String,dynamic> updatedChatUsers = {
                              'user_ids.${user.id}': !userIsRegistered
                            };

                            final batch = FirebaseFirestore.instance.batch();
                            batch.update(eventRef, updatedEventUsers);
                            batch.update(chatRef, updatedChatUsers);
                            await batch.commit();


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
