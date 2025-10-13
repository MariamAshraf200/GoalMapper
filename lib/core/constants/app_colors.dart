import 'package:flutter/material.dart';

class AppColors {
  static const Color defaultColor = Colors.blue; // blueGrey
  //Color(0xff867cef);
  // Color(0xFF1A5276);
  static Color defaultBackgroundColor = Colors.grey.shade100;
  static Color secondBackgroundColor = Colors.grey.shade300;
  static Color basicColor = Colors.white;
  static Color primaryColor = Colors.black;
  // static Color ? additionalColor = Colors.grey[200];
  // Make secondary color follow the defaultColor so the theme is consistent.
  static Color secondaryColor = defaultColor;
}
