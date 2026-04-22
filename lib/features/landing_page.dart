import 'package:flutter/material.dart';
import 'landing/landing_helpers.dart';
import 'landing/landing_navbar.dart';
import 'landing/landing_hero.dart';
import 'landing/landing_statistics.dart';
import 'landing/landing_features.dart';
import 'landing/landing_about.dart';
import 'landing/landing_testimonials.dart';
import 'landing/landing_footer.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  // Keep static color references for backward compatibility
  static const Color mPurple = LandingColors.mPurple;
  static const Color mBg = LandingColors.mBg;
  static const Color mText = LandingColors.mText;
  static const Color mSubText = LandingColors.mSubText;
  static const Color mGlass = LandingColors.mGlass;
  static const Color mAccent = LandingColors.mAccent;
  static const Color mPurpleLight = LandingColors.mPurpleLight;

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _featuresKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1200;

    return Scaffold(
      backgroundColor: LandingColors.mBg,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            LandingNavbar(
              isDesktop: isDesktop,
              onFeaturesTap: () => _scrollToSection(_featuresKey),
              onAboutTap: () => _scrollToSection(_aboutKey),
            ),
            LandingHero(isDesktop: isDesktop, screenWidth: screenWidth),
            LandingStatistics(isDesktop: isDesktop),
            LandingFeaturesGallery(isDesktop: isDesktop, sectionKey: _featuresKey),
            LandingAbout(isDesktop: isDesktop, sectionKey: _aboutKey),
            LandingTestimonials(isDesktop: isDesktop),
            LandingFooter(isDesktop: isDesktop),
          ],
        ),
      ),
    );
  }
}
