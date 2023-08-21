import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/spotlight.dart';

class SpotlightWidget extends StatefulWidget {
  final List<Spotlight> spotlights;

  SpotlightWidget({required this.spotlights});

  @override
  State<SpotlightWidget> createState() => _SpotlightWidgetState();
}

class _SpotlightWidgetState extends State<SpotlightWidget> {
  int _currentIndex = 0;


  void _changeHighlights() {
    setState(() {
    _currentIndex = (_currentIndex + 1) % widget.spotlights.length;
    });
  }

  void _showMoreInfo() {
    print(widget.spotlights[_currentIndex].title);

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
    return GestureDetector(
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
                  widget.spotlights[_currentIndex].title,
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
                for (int i = 0; i < widget.spotlights.length; i++)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(Icons.circle, size: 8, color: _currentIndex == i ? Colors.white : Colors.grey),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
