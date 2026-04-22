import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Shared color constants and helpers for the landing page.
class LandingColors {
  static const Color mPurple = Color(0xFF7C5CFC);
  static const Color mBg = Color(0xFFFBFBFF);
  static const Color mText = Color(0xFF1A1A2E);
  static const Color mSubText = Color(0xFF6B6B8E);
  static const Color mGlass = Color(0xEBFFFFFF);
  static const Color mAccent = Color(0xFFBCB1FF);
  static const Color mPurpleLight = Color(0xFFE0D7FF);
}

/// Poppins font helper
TextStyle poppins({
  double fontSize = 16,
  FontWeight fontWeight = FontWeight.w400,
  Color color = LandingColors.mText,
  double height = 1.4,
  FontStyle fontStyle = FontStyle.normal,
}) {
  return GoogleFonts.poppins(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    height: height,
    fontStyle: fontStyle,
  );
}

/// Reusable badge widget
Widget buildBadge(String text) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    decoration: BoxDecoration(
      color: LandingColors.mPurple.withOpacity(0.1),
      borderRadius: BorderRadius.circular(30),
    ),
    child: Text(
      text,
      style: poppins(color: LandingColors.mPurple, fontWeight: FontWeight.bold, fontSize: 14),
    ),
  );
}
