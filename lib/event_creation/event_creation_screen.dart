
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/authentication/SocietyAuthentication.dart';
import '../models/event.dart';
class EventCreationScreen extends StatefulWidget {
  @override
  _EventCreationScreenState createState() => _EventCreationScreenState();
}

class _EventCreationScreenState extends State<EventCreationScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late DateTime _startTime;
  late DateTime _endTime;

  String? _titleError;
  String? _descriptionError;
  String? _locationError;
  String? _startTimeError;
  String? _endTimeError;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _locationController = TextEditingController();
    _startTime = DateTime.now();
    _endTime = _startTime.add(Duration(hours: 2));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Create Event',
          style: TextStyle(color: Colors.black, fontFamily: 'Inter'),
        ),
        iconTheme: IconThemeData(color: Colors.black), // Set the back icon color
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                errorText: _titleError,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                errorText: _descriptionError,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Location',
                errorText: _locationError,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Start Time: ${_startTime.toString()}'),
                ElevatedButton(
                  onPressed: () async {
                    final DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: _startTime,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (selectedDate != null) {
                      final TimeOfDay? selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(_startTime),
                      );
                      if (selectedTime != null) {
                        DateTime newStartTime = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          selectedTime.hour,
                          selectedTime.minute,
                        );

                        setState(() {
                          _startTime = newStartTime;
                          _endTime = newStartTime.add(Duration(hours: 2));
                        });
                      }
                    }
                  },
                  child: Text(
                    'Pick',
                    style: TextStyle(color: Colors.white, fontFamily: 'Inter'),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('End Time: ${_endTime.toString()}'),
                ElevatedButton(
                  onPressed: () async {
                    final DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: _endTime,
                      firstDate: _startTime.add(Duration(minutes: 1)),
                      lastDate: DateTime(2101),
                    );
                    if (selectedDate != null) {
                      final TimeOfDay? selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(_endTime),
                      );
                      if (selectedTime != null) {
                        setState(() {
                          _endTime = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            selectedTime.hour,
                            selectedTime.minute,
                          );
                        });
                      }
                    }
                  },
                  child: Text(
                    'Pick',
                    style: TextStyle(color: Colors.white, fontFamily: 'Inter'),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                  ),
                ),
              ],
            ),
            if (_startTimeError != null)
              Text(
                _startTimeError!,
                style: TextStyle(color: Colors.red[800]),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: (){
                if(_validateFields()){
                  createEvent();
                  Navigator.pop(context);
                }


              },
              child: Text(
                'Create Event',
                style: TextStyle(color: Colors.white, fontFamily: 'Inter'),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }



  bool _validateFields() {
    setState(() {
      _titleError = _titleController.text.isEmpty ? 'Title is required.' : null;
      _descriptionError = _descriptionController.text.isEmpty ? 'Description is required.' : null;
      _locationError = _locationController.text.isEmpty ? 'Location is required.' : null;

      if (_titleController.text.length > 20) {
        _titleError = 'Title should be less than 20 characters.';
      }

      if (_locationController.text.length > 20) {
        _locationError = 'Location should be less than 20 characters.';
      }

      if (_descriptionController.text.length > 500) {
        _descriptionError = 'Description should be less than 500 characters.';
      }

      if (_startTime.isAfter(_endTime)) {
          _startTimeError = 'Start time cannot be after end time.';
        } else {
          _startTimeError = null;
        }

    });

    return (_titleError == null && _descriptionError == null && _locationError == null && _startTimeError == null);

  }

  void createEvent()async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final location = _locationController.text.trim();
    final startTime = Timestamp.fromDate(_startTime);
    final endTime = Timestamp.fromDate(_endTime);

    CollectionReference eventCollection = FirebaseFirestore.instance
        .collection("universities")
        .doc("university-of-warwick")
        .collection("events");
    CollectionReference chatsCollection = FirebaseFirestore.instance
        .collection("universities")
        .doc("university-of-warwick")
        .collection("chats");

    Map<String, dynamic> newEvent = {
      "title": title,
      "description": description,
      "location": location,
      "start_time": startTime,
      "end_time": endTime,
      "points": 0,
      "society": SocietyAuthentication.instance.societyInfo!.toJson(),
      "images": [],
      "registered_users": {},
    };



    DocumentReference eventRef = eventCollection.doc();
    DocumentReference chatRef = chatsCollection.doc(eventRef.id);

    Map<String, dynamic> newChat = {
      "event": {
        "title" : title,
        "location": location,
        "start_time": startTime,
        "end_time": endTime,
        "ref" : eventRef
      },
      "last_time_message_sent" : null,
      "messages" : [],
      "society" : SocietyAuthentication.instance.societyInfo!.toJson(),
      "users" :{}
    };


    final batch = FirebaseFirestore.instance.batch();
    batch.set(eventRef, newEvent);
    batch.set(chatRef, newChat);
    await batch.commit();


  }

}
