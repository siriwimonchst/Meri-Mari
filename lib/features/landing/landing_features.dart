import 'dart:ui';
import 'package:flutter/material.dart';
import 'landing_helpers.dart';

class LandingFeaturesGallery extends StatelessWidget {
  final bool isDesktop;
  final GlobalKey sectionKey;

  const LandingFeaturesGallery({super.key, required this.isDesktop, required this.sectionKey});

  @override
  Widget build(BuildContext context) {
    final screenImages = List.generate(11, (i) => 'assets/screen${i + 1}.png');

    return Container(
      key: sectionKey,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 100 : 20, vertical: 100),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [LandingColors.mBg, LandingColors.mPurpleLight.withOpacity(0.15), LandingColors.mBg],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          buildBadge('App Preview'),
          const SizedBox(height: 20),
          Text(
            'Explore Our Features',
            style: poppins(fontSize: 42, fontWeight: FontWeight.w900, height: 1.2),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Text(
            'Take a look at every screen of the Meri-Mari app — designed for a seamless experience.',
            style: poppins(fontSize: 18, color: LandingColors.mSubText, height: 1.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),
          SizedBox(
            height: isDesktop ? 520 : 420,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse, PointerDeviceKind.trackpad},
              ),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: screenImages.length,
                separatorBuilder: (_, __) => const SizedBox(width: 25),
                itemBuilder: (_, index) => _buildGalleryPhone(screenImages[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryPhone(String assetPath) {
    final w = isDesktop ? 230.0 : 180.0;
    final h = isDesktop ? 480.0 : 380.0;

    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(35),
        border: Border.all(color: const Color(0xFF262628), width: 6),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 10)),
          BoxShadow(color: LandingColors.mPurple.withOpacity(0.05), blurRadius: 30, spreadRadius: 2),
        ],
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(29)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(29),
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Image.asset(assetPath, fit: BoxFit.cover, alignment: Alignment.center),
              ),
            ),
          ),
          Positioned(
            top: 0, left: 0, right: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 80,
                height: 20,
                decoration: const BoxDecoration(
                  color: Color(0xFF1C1C1E),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(14),
                    bottomRight: Radius.circular(14),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
