import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:warwicksocietyapp/authentication/SocietyAuthentication.dart';
import '../models/society_info.dart';

class ManageSocietyAccountScreen extends StatefulWidget {
  const ManageSocietyAccountScreen({super.key});

  @override
  _ManageSocietyAccountScreenState createState() => _ManageSocietyAccountScreenState();
}

class _ManageSocietyAccountScreenState extends State<ManageSocietyAccountScreen> {
  final SocietyInfo society = SocietyAuthentication.instance.societyInfo!;
  TextEditingController societyNameController = TextEditingController(text: SocietyAuthentication.instance.societyInfo!.name);

  final _formKey = GlobalKey<FormState>();

  bool _contentModified = false;
  String? _selectedImagePath;

  String formatDateTime(DateTime dateTime) {
    final monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August',
      'September', 'October', 'November', 'December'
    ];

    final day = dateTime.day.toString().padLeft(2, '0');
    final month = monthNames[dateTime.month - 1];
    final year = dateTime.year.toString();

    return '$day. $month $year';
  }



  Future<void> _selectImage() async {
    final picker = ImagePicker();

    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImagePath = pickedImage.path;
        _contentModified = true;
      });
    }
  }

  String formatFullName(String fullName){
    return fullName.trim();
  }
  String? validateSocietyName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Society name is required';
    }

    // Remove leading and trailing whitespace
    value = formatFullName(value);

    if (value==society.name) return null;

    // Check if the full name contains only alphabetical characters and spaces
    if (!RegExp(r'^[a-zA-Z\s]{1,25}$').hasMatch(value)) {
      return 'Society name must be between 1 and 25 alphabetical characters and spaces only';
    }

    return null; // Validation passed
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(top: 28),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Form(
              key:_formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(Icons.arrow_back),
                      ),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/icons/profile/filter.png', // Replace with your image path
                            width: 24,
                            height: 24,
                            fit: BoxFit.contain,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 16,),
                  Text("Manage Account", style: TextStyle(
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                      fontSize: 18
                  ),),
                  SizedBox(height: 2,),
                  Text("Edit and update society information", style: TextStyle(
                    fontFamily: "Inter",
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Color(0xFF777777),
                  ),),
                  SizedBox(height: 16,),
                  GestureDetector(
                    onTap: _selectImage,
                    child: Stack(
                      children: [
                        Container(
                          width: 128,
                          height: 128,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 4,
                            ),
                            image: DecorationImage(
                              image: (_selectedImagePath == null) ? NetworkImage(society.logoUrl) : Image.file(File(_selectedImagePath!)).image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(100)
                            ),
                            child: Center(
                              child: ImageIcon(
                                AssetImage('assets/icons/profile/edit_white.png'),
                                size: 24,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )

                      ],
                    ),
                  ),
                  SizedBox(height: 8,),
                  TextFormField(
                    validator: validateSocietyName,
                    onChanged: (text) => setState(() {
                      _contentModified = true;
                    }),
                    style: TextStyle(
                        fontFamily: "Inter",
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                    ),
                    controller: societyNameController,
                    decoration: InputDecoration(
                      labelText: "Name",
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
                  SizedBox(height: 16.0),

                ],
              ),
            ),
            if(_contentModified)
              GestureDetector(
                onTap: saveChanges,
                child: Container(
                  width: 130,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(
                    child: Text(
                      "Save changes",
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
        ),
      ),
    );
  }

  Future<String> uploadImageToFirebaseStorage(String imagePath) async {
    final imageFile = File(imagePath);

    final Reference storageReference =
    FirebaseStorage.instance.ref().child('society_logos/${society.ref.id}.jpg');

    final UploadTask uploadTask = storageReference.putFile(imageFile);
    await uploadTask;
    final String downloadURL = await storageReference.getDownloadURL();

    return downloadURL;
  }
  void saveChanges() async {


    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _contentModified = false;
    });

    String societyName = formatFullName(societyNameController.text);


      society.ref.update({
        "name" :societyName,

      });


    Navigator.pop(context);
    if(_selectedImagePath != null) {
      final downloadUrl = await uploadImageToFirebaseStorage(_selectedImagePath!);
      society.ref.update({"logo_url" : downloadUrl});
    }

    if(context.mounted){
      setState(() {
        _contentModified = false;
      });
    }

    SocietyAuthentication.instance.refresh();

  }

}
