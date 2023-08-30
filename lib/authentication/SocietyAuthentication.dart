import '../models/society_info.dart';

class SocietyAuthentication {
  SocietyInfo? societyInfo;

  SocietyAuthentication._privateConstructor();

  static final SocietyAuthentication _instance = SocietyAuthentication._privateConstructor();

  static SocietyAuthentication get instance => _instance;

  bool get isSociety => societyInfo != null;
}