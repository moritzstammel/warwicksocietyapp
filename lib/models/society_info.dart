
import 'package:cloud_firestore/cloud_firestore.dart';

class SocietyInfo {
  final String name;
  final String logoUrl;
  final DocumentReference ref;

  SocietyInfo({required this.name, required this.logoUrl,required this.ref});



}
