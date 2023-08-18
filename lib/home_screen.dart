import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<String> _highlights = ['Freshers Events', 'WDSS Newsletter', 'Piano News', 'Chem News'];
  bool _isMoreInfoPopupVisible = false;
  bool _disposed = false;

  void _changeHighlights() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _highlights.length;
    });
  }

  void _showMoreInfo() {
    print(_highlights[_currentIndex]);

  }

  @override
  void initState() {
    super.initState();
    // Start the highlights changing loop
    _startHighlightsLoop();
  }



  // Function to start changing highlights in a loop
  void _startHighlightsLoop() {
    if (!super.mounted) return;
    Future.delayed(Duration(seconds: 5), () {
      if (!super.mounted) return;
      _changeHighlights();
      _startHighlightsLoop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              _changeHighlights();
            },
            child: Container(
              color: Colors.blue[900],
              padding: EdgeInsets.only(left: 16, right: 16, top: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _highlights[_currentIndex],
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      ElevatedButton(
                        onPressed: _showMoreInfo,
                        child: Text('More Info'),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < _highlights.length; i++)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(Icons.circle, size: 8, color: _currentIndex == i ? Colors.white : Colors.grey),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                EventListItem('Event 1', '10:00 AM', 'August 10'),
                EventListItem('Event 2', '2:00 PM', 'August 15'),
                EventListItem('Event 3', '6:30 PM', 'August 20'),
                // Add more EventListItems here
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EventListItem extends StatelessWidget {
  final String eventName;
  final String eventTime;
  final String eventDate;

  EventListItem(this.eventName, this.eventTime, this.eventDate);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(eventName),
      subtitle: Text('$eventTime • $eventDate'),
      // Add action for the event list item here
    );
  }
}