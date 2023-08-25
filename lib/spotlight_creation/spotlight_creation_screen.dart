import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:warwicksocietyapp/widgets/spotlight_card.dart';

import '../models/society_info.dart';
import '../models/spotlight.dart';

class SpotlightCreationScreen extends StatefulWidget {
  @override
  _SpotlightCreationScreenState createState() => _SpotlightCreationScreenState();
}

class _SpotlightCreationScreenState extends State<SpotlightCreationScreen> {
  final TextEditingController _titleController = TextEditingController();
  final ValueNotifier<String> _titleNotifier = ValueNotifier<String>('');

  DateTime? _selectedDateTime;
  String? _selectedImagePath;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _selectImage() async {
    final picker = ImagePicker();

    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImagePath = pickedImage.path;
      });
    }
  }

  void _selectDateTime(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    DateTime initialDate = _selectedDateTime ?? currentDate;

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(currentDate.year - 1),
      lastDate: DateTime(currentDate.year + 1),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark(), // Change to ThemeData.light() for light theme
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    print("xxx");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Create new Spotlight',
          style: TextStyle(color: Colors.black, fontFamily: 'Inter'),
        ),
        elevation: 0,
          iconTheme: IconThemeData(color: Colors.black)
      ),
      body:
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                onChanged: (value) {
                  _titleNotifier.value = value;
                },
                decoration: InputDecoration(hintText: 'e.g. New Podcast Episode'),
              ),

              SizedBox(height: 20),
              GestureDetector(
                onTap: () => _selectDateTime(context),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today),
                    SizedBox(width: 10),
                    Text(
                      _selectedDateTime != null
                          ? 'Selected Date: ${_selectedDateTime!.toLocal()}'
                          : 'Select Date and Time',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: _selectImage,
                child: Row(
                  children: [
                    Icon(Icons.image),
                    SizedBox(width: 10),
                    Text(
                      _selectedImagePath != null ? 'Image selected' : 'Select an Image',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              _selectedImagePath != null
                  ? Image.file(
                File(_selectedImagePath!),
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ) // Display selected image preview
                  : Container(), // Empty container if no image is selected
              SizedBox(height: 20),
              ValueListenableBuilder(
                valueListenable: _titleNotifier,
                builder: (context, title, child) {
                  return Container(
                    width: double.infinity,
                    child: SpotlightCard(
                      spotlights: [Spotlight(
                        title: title == "" ? "Example \nAnnouncement" : title,
                        text: "",
                        society: SocietyInfo(
                            name: "Warwick Piano Society",
                            logoUrl: "test.de",
                            ref:FirebaseFirestore.instance.doc("/universities/university-of-warwick/societies/S3lJHuxEAzhBlIx1EVED")
                        ),
                        image: _selectedImagePath != null
                            ? Image.file(File(_selectedImagePath!),).image
                            : AssetImage("assets/spotlights_background_image.jpg"),
                      )],
                      editable: false,
                    ),
                  );
                },
              ),




              ElevatedButton(
                onPressed: () {
                  // Implement logic to save the spotlight
                },
                child: Text('Create Spotlight'),
              ),
            ],
          ),
        ),

    );
  }
}
