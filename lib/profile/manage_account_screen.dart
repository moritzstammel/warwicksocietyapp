import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:warwicksocietyapp/authentication/FirestoreAuthentication.dart';
import 'package:warwicksocietyapp/models/firestore_user.dart';

class ManageAccountScreen extends StatefulWidget {
  @override
  _ManageAccountScreenState createState() => _ManageAccountScreenState();
}

class _ManageAccountScreenState extends State<ManageAccountScreen> {
  final FirestoreUser user = FirestoreAuthentication.instance.firestoreUser!;
  TextEditingController fullNameController = TextEditingController(text: FirestoreAuthentication.instance.firestoreUser!.fullName);
  TextEditingController usernameController = TextEditingController(text: "@${FirestoreAuthentication.instance.firestoreUser!.username}");

  final _formKey = GlobalKey<FormState>();
  bool currentUsernameIsAvailable = false;
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
  String formatUsername(String username){
    username = username.trim().toLowerCase();

    // Remove leading "@" characters
    username = username.replaceAll(RegExp('^@+'), '');
    return username;
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }

    value = formatUsername(value);

    if(value==user.username) return null;

    // Check if the username is alphanumeric and within the length range
    if (!RegExp(r'^[a-zA-Z0-9]{3,15}$').hasMatch(value)) {
      return 'Username must be between 3 and 15 alphanumeric characters';
    }

    // Check if the username is available
    if (!currentUsernameIsAvailable) {
      return 'This username is already taken';
    }

    return null; // Validation passed
  }
  String formatFullName(String fullName){
    return fullName.trim();
  }
  String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is required';
    }

    // Remove leading and trailing whitespace
    value = formatFullName(value);

    if (value==user.fullName) return null;

    // Check if the full name contains only alphabetical characters and spaces
    if (!RegExp(r'^[a-zA-Z\s]{1,25}$').hasMatch(value)) {
      return 'Full name must be between 1 and 25 alphabetical characters and spaces only';
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
                  Text("Edit and update personal information", style: TextStyle(
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
                              image: (_selectedImagePath == null) ? NetworkImage(user.imageUrl) : Image.file(File(_selectedImagePath!)).image,
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
                    validator: validateFullName,
                    onChanged: (text) => setState(() {
                      _contentModified = true;
                    }),
                    style: TextStyle(
                        fontFamily: "Inter",
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                    ),
                    controller: fullNameController,
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
                  TextFormField(
                    validator: validateUsername,
                    onChanged: (text) async {
                      if(text.trim().toLowerCase().length <=2) return;
                      final usernameAvailable = await usernameIsAvailable(text.trim().toLowerCase());
                      setState(() {
                        _contentModified = true;
                        currentUsernameIsAvailable = usernameAvailable;
                      });
                    },
                    style: TextStyle(
                        fontFamily: "Inter",
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF888888)
                    ),
                    controller: usernameController,

                    decoration: InputDecoration(
                      labelText: "Username",
                      counterStyle: TextStyle(fontSize: 23),
                      suffixIcon: ImageIcon(
                          AssetImage('assets/icons/profile/edit_black.png'),
                          size: 16,
                          color: Colors.black),
                      labelStyle: TextStyle(
                          fontFamily: "Inter",
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: Colors.black
                      ),
                    ),
                  ),
                  SizedBox(height: 24,),
                  Text("Email",style: TextStyle(
                      fontFamily: "Inter",
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                      color: Colors.black
                  ),),
                  SizedBox(height: 8,),
                  Text(user.email,style: TextStyle(
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.black
                  ),),
                  SizedBox(height: 16,),
                  Text("Date joined",style: TextStyle(
                      fontFamily: "Inter",
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                      color: Colors.black
                  ),),
                  SizedBox(height: 8,),
                  Text(formatDateTime(user.createdAt),style: TextStyle(
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.black
                  ),),
                  SizedBox(height: 24,),
                  GestureDetector(
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pop(context);
                    },
                    child: Text("Sign Out",style: TextStyle(
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Color(0xFFDD0000)
                    ),),
                  ),
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
  Future<bool> usernameIsAvailable(String username) async{
    CollectionReference userCollection = FirebaseFirestore.instance.collection("universities/university-of-warwick/users");
    final result = await userCollection.where("username",isEqualTo: username).count().get();
    return (0 == result.count);
  }

  Future<String> uploadImageToFirebaseStorage(String imagePath) async {
    print("test");
    final String userId = FirestoreAuthentication.instance.firestoreUser!.id;
    final imageFile = File(imagePath);

    final Reference storageReference =
    FirebaseStorage.instance.ref().child('profile_pictures/$userId.jpg');

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

    String username = formatUsername(usernameController.text);
    String fullName = formatFullName(fullNameController.text);

    final String userId = FirestoreAuthentication.instance.firestoreUser!.id;
    DocumentReference userRef = FirebaseFirestore.instance.doc("universities/university-of-warwick/users/$userId");


    if(await usernameIsAvailable(username) || username == user.username){
      userRef.update({
        "username" : username,
        "full_name" : fullName,
      });
    }

    if(_selectedImagePath != null) {
      final downloadUrl = await uploadImageToFirebaseStorage(_selectedImagePath!);
      userRef.update({"image_url" : downloadUrl});
    }

    if(context.mounted){
      setState(() {
        _contentModified = false;
      });
    }



  }

}
