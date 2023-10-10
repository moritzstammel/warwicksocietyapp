
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:warwicksocietyapp/authentication/SocietyAuthentication.dart';
import 'package:warwicksocietyapp/models/event.dart';
import 'dart:io';
import '../firestore_helper.dart';
import '../models/society_info.dart';

class EventCreationScreen extends StatefulWidget {
  final Event? event;
  EventCreationScreen({this.event});

  @override
  _EventCreationScreenState createState() => _EventCreationScreenState();
}

class _EventCreationScreenState extends State<EventCreationScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late DateTime _startTime;
  late DateTime _endTime;
  String? _selectedImagePath;
  String? _titleError;
  String? _descriptionError;
  String? _locationError;
  String? _startTimeError;
  late bool editEvent;

  String? _selectedTag; // Default duration is 1 day

  List<String> _tagOptions = []; // Duration options in days


  @override
  void initState() {
    super.initState();
    editEvent = (widget.event != null);
    fetchTags();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _locationController = TextEditingController();
    _startTime = DateTime.now();
    _endTime = _startTime.add(Duration(hours: 2));

    if(editEvent){
      _titleController.text = widget.event!.title;
      _descriptionController.text = widget.event!.description;
      _locationController.text = widget.event!.location;
      _startTime = widget.event!.startTime;
      _endTime = widget.event!.endTime;
      _selectedTag = widget.event!.tag;
    }


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
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          '${ editEvent ? 'Edit':'Create'} Event',
          style: TextStyle(color: Colors.black, fontFamily: 'Inter'),
        ),
        iconTheme: IconThemeData(color: Colors.black), // Set the back icon color
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween ,
          children: [
            Column(
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
                    Text('Start Time: ${formatDate(_startTime)}'),
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
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                            )),
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor: MaterialStateProperty.all(Colors.black),

                      ),

                    ),
                  ],
                ),

                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('End Time: ${formatDate(_endTime)}'),
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
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            )),
                        elevation: MaterialStateProperty.all(0),
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
                SizedBox(height: 8),
                GestureDetector(
                  onTap: _selectImage,
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: (_selectedImagePath != null && _selectedImagePath!.isNotEmpty)
                        ? Image.file(File(_selectedImagePath!), fit: BoxFit.cover,)
                        : (editEvent ? Image(image: NetworkImage(widget.event!.images[0],),fit: BoxFit.cover,) : Icon(Icons.add_photo_alternate, color: Colors.black)),
                  ),
                ),
                Row(
                  children: [
                    Text('Select a tag'),
                    SizedBox(width: 8),
                    DropdownButton<String>(
                      value: _selectedTag,
                      onChanged: (String? newValue) {
                        if (newValue == null) return;
                        setState(() {
                          _selectedTag = newValue;
                        });
                      },
                      items: _tagOptions.map((String tag) {
                        return DropdownMenuItem<String>(
                          value: tag,
                          child: Text(tag),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                SizedBox(height: 20),


              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child:
              (!editEvent) ?
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: _createEvent,
                    child: Container(
                      width: 130,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: Text(
                          "Create Event",
                          style: TextStyle(
                            fontFamily: "Inter",
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
                  :
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _deleteEvent,
                    child: Container(
                      width: 130,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(0xFFDD0000),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: Text(
                          "Delete Event",
                          style: TextStyle(
                            fontFamily: "Inter",
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _editEvent,
                    child: Container(
                      width: 130,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: Text(
                          "Save Changes",
                          style: TextStyle(
                            fontFamily: "Inter",
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
              ,
            ),
          ],
        ),
      ),
    );
  }
  String formatDate(DateTime dateTime) {
    String day = dateTime.day.toString().padLeft(2, '0');
    String month = dateTime.month.toString().padLeft(2, '0');
    String year = dateTime.year.toString();
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');

    return '$day.$month.$year $hour:$minute';
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
  void _editEvent() async {
      if (!_validateFields()) return;
      if (_selectedTag == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please select an tag for the event"),
        ));
        return;
      }

      Navigator.of(context).pop();
      DateTime now = DateTime.now();
      String imageUrl = (_selectedImagePath != null) ? await uploadImageToFirebaseStorage(_selectedImagePath!, now.hashCode.toString()) : widget.event!.images[0];

      final title = _titleController.text.trim();
      final description = _descriptionController.text.trim();
      final location = _locationController.text.trim();
      final startTime = _startTime;
      final endTime = _endTime;

      Event event = Event(
          id: widget.event!.id,
          title: title,
          description: description,
          location: location,
          startTime: startTime,
          endTime: endTime,
          points: 0,
          societyInfo: SocietyAuthentication.instance.societyInfo!,
          images: [imageUrl],
          registeredUsers: {},
          tag: _selectedTag!);

      FirestoreHelper.instance.updateEvent(event);

      }
  Future<void> _deleteEvent() async {
    // Show a confirmation dialog
    bool deleteConfirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this event?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User canceled the delete
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User confirmed the delete
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    // If the user confirmed the delete, trigger the deletion in Firestore
    if (deleteConfirmed == true) {
      try {
        Navigator.of(context).pop();
        await FirestoreHelper.instance.deleteEvent(widget.event!);
        // Optionally, you can show a success message or navigate back to a previous screen.
      } catch (error) {
        // Handle any errors that occur during the deletion process.
        print('Error deleting event: $error');
        // Optionally, you can show an error message to the user.
      }
    }
  }
  void _createEvent()async {
    if(!_validateFields()) return;
    if (_selectedImagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please select an image for the event"),
      ));
      return;
    }
    if (_selectedTag == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please select an tag for the event"),
      ));
      return;
    }
    Navigator.pop(context);

    DateTime now = DateTime.now();
    String imageUrl = await uploadImageToFirebaseStorage(_selectedImagePath!, now.hashCode.toString());



    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final location = _locationController.text.trim();
    final startTime = _startTime;
    final endTime = _endTime;

    Event newEvent = Event(
        id: "",
        title: title,
        description: description,
        location: location,
        startTime: startTime,
        endTime: endTime,
        points: 0,
        societyInfo: SocietyAuthentication.instance.societyInfo!,
        images: [imageUrl],
        registeredUsers: {},
        tag: _selectedTag!);

    FirestoreHelper.instance.createEvent(newEvent);


  }
  Future<String> uploadImageToFirebaseStorage(String imagePath,String id) async {
    final SocietyInfo society = SocietyAuthentication.instance.societyInfo!;
    final imageFile = File(imagePath);

    final Reference storageReference =
    FirebaseStorage.instance.ref().child('events/${society.ref.id}/$id.jpg');

    final UploadTask uploadTask = storageReference.putFile(imageFile);
    await uploadTask;
    final String downloadURL = await storageReference.getDownloadURL();

    return downloadURL;
  }

  Future<void> fetchTags() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('universities')
        .doc('university-of-warwick')
        .collection('tags')
        .get();

    setState(() {
      _tagOptions =
          snapshot.docs.map((doc) => doc.id).toList();
    });
  }

}
