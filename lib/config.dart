import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppConfig {
  static String tradeTitle = 'İkinci El ve Sıfır Alışveriş';
  static String categories = 'Kategoriler';
  static const String nullProfilePhotoURL =
      'https://www.tech101.in/wp-content/uploads/2018/07/blank-profile-picture.png';

  static Color tradePrimaryColor = const Color.fromRGBO(25, 118, 210, 1);

  static Color tradeSecondaryColor = const Color.fromARGB(255, 33, 158, 188);

  static Color tradeThirtyColor = Colors.yellow[800]!;

  static Color tradeTextColor = Colors.grey[850]!;

  static TextStyle get font => GoogleFonts.poppins();
}
