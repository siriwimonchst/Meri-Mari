// lib/core/app_theme.dart
// ─── Centralised Design Tokens ────────────────────────────────────────────────
// Single source of truth for the purple palette used throughout the app.
// Import this file wherever colour constants are needed instead of redeclaring
// local `_k*` constants in every screen file.
import 'package:flutter/material.dart';

// ── Palette ───────────────────────────────────────────────────────────────────
const Color kPurple       = Color(0xFF7B5EA7);
const Color kPurpleLight  = Color(0xFFAB9DC4);
const Color kPurpleFaint  = Color(0xFFF4F0FA);
const Color kPurpleBorder = Color(0xFFDDD6E8);
const Color kText         = Color(0xFF1A1A2E);
const Color kSubText      = Color(0xFFB0A8C4);
const Color kErrorRed     = Color(0xFFB71C1C); // Material Red 900
const Color kErrorRedDark = Color(0xFF8B0000); // Dark Blood Red
const Color kWarningOrange = Color(0xFFE65100); // Premium Dark Orange (Orange 900)

// ── Auth-screen layout ratios ─────────────────────────────────────────────────
/// Height fraction of the purple gradient background strip.
const double kAuthBgHeightRatio   = 0.45;
/// Height fraction of the white card that slides up over the gradient.
const double kAuthCardHeightRatio = 0.75;

// ── Decorative circle sizes (used in auth & register background) ──────────────
const double kDecorOuterSize  = 500.0;
const double kDecorMidSize    = 400.0;
const double kDecorInnerSize  = 300.0;

// ── Decorative circle offsets (negative = partially off-screen) ───────────────
const double kDecorOuterOffset = -150.0;
const double kDecorMidOffset   = -100.0;
const double kDecorInnerOffset =  -50.0;

// ── Opacity for decorative circle borders ─────────────────────────────────────
const double kDecorBorderAlpha = 0.15;

// ─── Theme ────────────────────────────────────────────────────────────────────
class MeriMariTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: kPurple,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.fromSeed(
        seedColor: kPurpleLight,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      fontFamily: 'sans-serif',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: kPurple,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPurple,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}