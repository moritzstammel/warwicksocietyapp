import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:warwicksocietyapp/authentication/SocietyAuthentication.dart';
import 'package:warwicksocietyapp/firebase_helper.dart';
import 'dart:io';

import 'package:warwicksocietyapp/widgets/spotlight_card.dart';


import '../authentication/FirestoreAuthentication.dart';
import '../models/society_info.dart';
import '../models/spotlight.dart';

class SpotlightCreationScreen extends StatefulWidget {
  final Spotlight? spotlight;

  const SpotlightCreationScreen({this.spotlight});

  @override
  _SpotlightCreationScreenState createState() => _SpotlightCreationScreenState();
}

class _SpotlightCreationScreenState extends State<SpotlightCreationScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _linksController = TextEditingController();


  final ValueNotifier<String> _titleNotifier = ValueNotifier<String>('');
  int _selectedDuration = 1; // Default duration is 1 day

  final List<int> _durationOptions = [1, 2, 3, 5, 7, 14,30]; // Duration options in days

  String? _selectedImagePath;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _linksController.dispose();
    super.dispose();
  }


  @override
  void initState() {
    super.initState();
    if (widget.spotlight != null){
      _titleController.text = widget.spotlight!.title;
      _titleNotifier.value = widget.spotlight!.title;
      _descriptionController.text = widget.spotlight!.text;
      _linksController.text = widget.spotlight!.links.join(";");
    }
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

  String? validateTitle(String? title) {
    if (title == null || title.isEmpty) {
      return 'Title cannot be empty';
    }
    final RegExp alphaRegex = RegExp(r'^[a-zA-Z\s]+$');
    if (!alphaRegex.hasMatch(title)) {
      return 'Title should only contain spaces or alphabetical symbols';
    }
    return null;
  }

  List<String> splitAndTrimLinks(String text) => text.split(';').map((link) => link.trim()).toList();

  String? validateLinks(String? links) {
    if (links == null || links.isEmpty) {
      // Return null if the string is empty or null (no validation error)
      return null;
    }

    // Split the input string by semicolons to get individual links
    List<String> linkList = links.split(';');

    if (linkList.length > 3) {
      // Check if there are more than three links
      return 'Up to three links are allowed';
    }

    // Regular expression to validate each link as a URL
    final RegExp urlRegex = RegExp(
        r'^(https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]*[-A-Za-z0-9+&@#/%=~_|]');

    for (String link in linkList) {
      if (!urlRegex.hasMatch(link.trim())) {
        // Check if any link is not a valid URL
        return 'Invalid URL format';
      }
    }

    // No validation errors
    return null;
  }
  Future<void> _editSpotlight() async {

    String? titleValidationResult = validateTitle(_titleController.text);


    String? linksValidationResult = validateLinks(_linksController.text);


    if (titleValidationResult != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(titleValidationResult),
      ));
      return;
    }

    if (linksValidationResult != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(linksValidationResult),
      ));
      return;
    }
    Navigator.pop(context);
    DateTime now = DateTime.now();

    String title = _titleController.text;
    String description = _descriptionController.text;
    List<String> links = splitAndTrimLinks(_linksController.text);
    String imageUrl = widget.spotlight!.imageUrl;
    if(_selectedImagePath != null){
      imageUrl = await uploadImageToFirebaseStorage(_selectedImagePath!, now.hashCode.toString());
    }



    Spotlight updatedSpotlight = Spotlight(
        id:widget.spotlight!.id,title: title, text: description, society: SocietyAuthentication.instance.societyInfo!, imageUrl: imageUrl, links: links, startTime: widget.spotlight!.startTime, endTime: widget.spotlight!.endTime);

    FirestoreHelper.instance.updateSpotlight(updatedSpotlight);

  }
  Future<void> _cancelSpotlight() async{
    FirestoreHelper.instance.cancelSpotlight(widget.spotlight!);
    Navigator.pop(context);
  }

  Future<void> _createSpotlight() async {

    String? titleValidationResult = validateTitle(_titleController.text);


    String? linksValidationResult = validateLinks(_linksController.text);


    if (titleValidationResult != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(titleValidationResult),
      ));
      return;
    }

    if (linksValidationResult != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(linksValidationResult),
      ));
      return;
    }
    if (_selectedImagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please select an image by clicking on the spotlight preview"),
      ));
      return;
    }
    Navigator.pop(context);
    DateTime now = DateTime.now();

    DateTime startTime = now;
    DateTime endTime = now.add(Duration(days: _selectedDuration));
    String title = _titleController.text;
    String description = _descriptionController.text;
    List<String> links = splitAndTrimLinks(_linksController.text);


    String imageUrl = await uploadImageToFirebaseStorage(_selectedImagePath!, now.hashCode.toString());

    Spotlight newSpotlight = Spotlight(
        id:"",title: title, text: description, society: SocietyAuthentication.instance.societyInfo!, imageUrl: imageUrl, links: links, startTime: startTime, endTime: endTime);

    FirestoreHelper.instance.createSpotlight(newSpotlight);

  }



  Future<String> uploadImageToFirebaseStorage(String imagePath,String id) async {
    final SocietyInfo society = SocietyAuthentication.instance.societyInfo!;
    final imageFile = File(imagePath);

    final Reference storageReference =
    FirebaseStorage.instance.ref().child('spotlights/${society.ref.id}/$id.jpg');

    final UploadTask uploadTask = storageReference.putFile(imageFile);
    await uploadTask;
    final String downloadURL = await storageReference.getDownloadURL();

    return downloadURL;
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
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
        Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(

                            validator: validateTitle,
                            onChanged: (value) {
                              _titleNotifier.value = value;
                            },
                            style: TextStyle(
                                fontFamily: "Inter",
                                fontWeight: FontWeight.bold,
                                fontSize: 16
                            ),
                            controller: _titleController,
                            decoration: InputDecoration(

                              labelText: "Title",
                              labelStyle: TextStyle(
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  color: Colors.black
                              ),
                              suffixIcon: ImageIcon(
                                AssetImage('assets/icons/profile/edit_black.png'),
                                size: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 8,),
                          TextFormField(
                            style: TextStyle(
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w500,
                                fontSize: 16
                            ),
                            controller: _descriptionController,
                            minLines: 2,
                            maxLines: 8,
                            decoration: InputDecoration(

                              labelText: "Description",
                              labelStyle: TextStyle(
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  color: Colors.black
                              ),
                              suffixIcon: ImageIcon(
                                AssetImage('assets/icons/profile/edit_black.png'),
                                size: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 8,),
                          TextFormField(
                            validator: validateLinks,
                            style: TextStyle(
                                fontFamily: "Inter",
                                fontWeight: FontWeight.bold,
                                fontSize: 16
                            ),
                            controller: _linksController,
                            decoration: InputDecoration(

                              labelText: "Up to 3 links seperated by semicolons (;)",
                              labelStyle: TextStyle(
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  color: Colors.black
                              ),
                              suffixIcon: ImageIcon(
                                AssetImage('assets/icons/profile/edit_black.png'),
                                size: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          if(widget.spotlight==null)
                          SizedBox(height: 16,),
                          if(widget.spotlight==null)
                             Row(
                              children: [
                                ImageIcon(
                                  AssetImage('assets/icons/events/calendar.png'),
                                  size: 24,
                                ),
                                SizedBox(width: 8),
                                Text('Select the duration of the spotlight'),
                                SizedBox(width: 8),
                                DropdownButton<int>(
                                  value: _selectedDuration,
                                  onChanged: (int? newValue) {
                                    if (newValue == null) return;
                                    setState(() {
                                      _selectedDuration = newValue;
                                    });
                                  },
                                  items: _durationOptions.map((int duration) {
                                    return DropdownMenuItem<int>(
                                      value: duration,
                                      child: Text('$duration ${duration == 1 ? "day" : "days"}'),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          SizedBox(height: 8,),
                          Text("Preview", style: TextStyle(
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w500,
                              fontSize: 18
                          ),),



                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8,),
                  ValueListenableBuilder(
                    valueListenable: _titleNotifier,
                    builder: (context, title, child) {
                      return Container(
                        width: double.infinity,
                        child: GestureDetector(
                          onTap: _selectImage,
                          child: SpotlightCard(
                              spotlights: [Spotlight(
                                id: "",
                                  title: title == "" ? "Freshers \nEvents" : title,
                                  text: "",
                                  society: SocietyAuthentication.instance.societyInfo!,
                                  image:  (_selectedImagePath != null)? Image.file(File(_selectedImagePath!),).image
                                      : ((widget.spotlight==null) ? AssetImage("assets/spotlights_background_image.jpg") : null),
                                  links: [],
                                  startTime: DateTime.now(),
                                  endTime: DateTime.now().add(Duration(days: 3)), imageUrl: (widget.spotlight==null) ? '' : widget.spotlight!.imageUrl
                              )],
                              editable: false, clickable: false

                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 8,),
                  Text("Click on the Spotlight to select an image"),
                ],
              ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child:
                  (widget.spotlight==null) ?
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: _createSpotlight,
                      child: Container(
                        width: 130,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                          child: Text(
                            "Create Spotlight",
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
                        onTap: _cancelSpotlight,
                        child: Container(
                          width: 130,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(0xFFDD0000),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Center(
                            child: Text(
                              "End Spotlight",
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
                        onTap: _editSpotlight,
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
}
