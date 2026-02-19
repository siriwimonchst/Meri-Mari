//กำหนดสีม่วง-ขาวและสไตล์แอป
import 'package:flutter/material.dart';

class MeriMariTheme {
  static const Color primaryPurple = Color(0xFF7E57C2); // สีม่วงหลัก
  static const Color lightPurple = Color(0xFFF3E5F5);   // ม่วงอ่อนสำหรับพื้นหลัง Tag

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryPurple,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.light(primary: primaryPurple),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: primaryPurple,
        elevation: 0,
      ),
      // สไตล์ปุ่มกด
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPurple,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}