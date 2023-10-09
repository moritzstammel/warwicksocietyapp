import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/error_screen.dart';
import 'package:warwicksocietyapp/models/firestore_user.dart';
import 'package:warwicksocietyapp/models/user_info.dart';
import 'package:warwicksocietyapp/widgets/society_card.dart';
import 'package:warwicksocietyapp/widgets/tag_card.dart';

class UserDetailsScreen extends StatefulWidget {
  final DocumentReference userRef;
  UserDetailsScreen({super.key,required this.userRef});
  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  late Stream<DocumentSnapshot> userStream;

  @override
  void initState() {
    super.initState();
    userStream = widget.userRef.snapshots();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<DocumentSnapshot>(
        stream: userStream,
        builder: (context, snapshot) {
          if(snapshot.hasError) return ErrorScreen();
          if(!snapshot.hasData) return Container();
          FirestoreUser user = FirestoreUser.fromJson(snapshot.data!.data() as Map<String,dynamic>, snapshot.data!.id);
          return SingleChildScrollView(
            child: Column(
              children: [

                  Stack(
                      children: [
                        Container(

                          height: 125,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(user.bannerUrl),
                                fit: BoxFit.cover,

                              ),
                              borderRadius: BorderRadius.circular(2)
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Column(

                            children: [
                              SizedBox(height: 22,),
                              Container(
                                margin: EdgeInsets.only(top: 35), // Adjust as needed
                                width: 128,
                                height: 128,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white, // Set the border color to white
                                    width: 4, // Set the border width
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(user.imageUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Text(user.fullName,style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold
                              ),),
                              SizedBox(height: 4,),
                              Text("@${user.username}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Color(0xFF888888)
                                ),)
                            ],
                          ),
                        ),
                        Positioned(
                          top: 45,
                          left: 20,
                          child:  GestureDetector(
                              onTap: Navigator.of(context).pop,
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(100)
                                ),
                                child: Center(child: ImageIcon(AssetImage('assets/icons/arrow-left-white.png'),color: Colors.white,),
                                ),
                              )),
                        ),
                      ]),




                SizedBox(height: 24),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(user.followedSocieties.isNotEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'SOCIETIES',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      if(user.followedSocieties.isNotEmpty)
                        Container(
                          height: 108, // Set an appropriate height
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: user.followedSocieties.values.length,
                            itemBuilder: (context, index) {
                              return SocietyCard(societyInfo: user.followedSocieties.values.toList()[index]);
                            },
                          ),
                        ),
                      if(user.tags.isNotEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Text(
                            'INTERESTED IN',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      if(user.tags.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: user.tags.keys.map((tagName) => TagCard(name: tagName)).toList(),
                      ),

                    ],
                  ),
                ),





                SizedBox(height: 8),
              ],
            ),
          );
        }
      ),
    );
  }
}
