import 'package:flutter/material.dart';
import 'landing_helpers.dart';

class LandingHero extends StatelessWidget {
  final bool isDesktop;
  final double screenWidth;

  const LandingHero({super.key, required this.isDesktop, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [LandingColors.mBg, LandingColors.mPurpleLight.withOpacity(0.3), LandingColors.mBg],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 100 : 20, vertical: 80),
      child: isDesktop
          ? Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(right: -100, top: -50, child: _buildBlobDecor()),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 10, child: _buildHeroContent(context)),
                    Expanded(flex: 12, child: _buildDualMockup()),
                  ],
                ),
              ],
            )
          : Column(
              children: [
                _buildHeroContent(context),
                const SizedBox(height: 60),
                _buildDualMockup(),
              ],
            ),
    );
  }

  Widget _buildBlobDecor() {
    return Container(
      width: 800,
      height: 700,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [LandingColors.mAccent.withOpacity(0.2), LandingColors.mPurple.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(200),
      ),
    );
  }

  Widget _buildHeroContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildBadge('High-Quality Second-Hand Marketplace'),
        const SizedBox(height: 25),
        Text(
          'Discover Your next\nUnique treasure.',
          style: poppins(fontSize: 72, fontWeight: FontWeight.w900, height: 1.05),
        ),
        const SizedBox(height: 25),
        Text(
          'Buy and sell collectibles, rare items, and premium second-hand goods\nwith 100% authentication and buyer protection.',
          style: poppins(fontSize: 18, color: LandingColors.mSubText, height: 1.6),
        ),
        const SizedBox(height: 40),
        Row(
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/'),
              style: ElevatedButton.styleFrom(
                backgroundColor: LandingColors.mPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 22),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 10,
                shadowColor: LandingColors.mPurple.withOpacity(0.4),
              ),
              child: Row(
                children: [
                  Text('Shop Now', style: poppins(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
                  const SizedBox(width: 10),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                ],
              ),
            ),
            const SizedBox(width: 20),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/'),
              child: Text('Start Selling →', style: poppins(color: LandingColors.mPurple, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ],
        ),
        const SizedBox(height: 50),
        _buildSocialProof(),
      ],
    );
  }

  Widget _buildSocialProof() {
    return Row(
      children: [
        const Icon(Icons.verified_user_rounded, color: LandingColors.mPurple, size: 28),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Verified Merchant Community', style: poppins(fontWeight: FontWeight.bold, fontSize: 14)),
            Text('Over 500,000 members nationwide.', style: poppins(color: LandingColors.mSubText, fontSize: 13)),
          ],
        ),
      ],
    );
  }

  Widget _buildDualMockup() {
    return SizedBox(
      height: 760,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Transform.rotate(
            angle: -0.05,
            child: _buildPhoneFrame(
              child: Image.asset('assets/screen1.png', fit: BoxFit.cover, alignment: Alignment.topCenter),
              width: 320,
              height: 660,
            ),
          ),
          const SizedBox(width: 20),
          Transform.translate(
            offset: const Offset(0, 30),
            child: Transform.rotate(
              angle: 0.05,
              child: _buildPhoneFrame(
                child: Image.asset('assets/last5.png', fit: BoxFit.cover, alignment: Alignment.topCenter),
                borderColor: LandingColors.mPurple.withOpacity(0.3),
                width: 320,
                height: 660,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneFrame({required Widget child, Color? borderColor, double width = 320, double height = 640}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(45),
        border: Border.all(color: borderColor ?? const Color(0xFF262628), width: 8),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 30, spreadRadius: 0, offset: const Offset(0, 20)),
          BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 40, spreadRadius: 5),
        ],
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(37)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(37),
              child: SizedBox(width: double.infinity, height: double.infinity, child: child),
            ),
          ),
          Positioned(
            top: 0, left: 0, right: 0,
            child: Align(alignment: Alignment.topCenter, child: _buildNotch()),
          ),
        ],
      ),
    );
  }

  Widget _buildNotch() {
    return Container(
      width: 120,
      height: 28,
      decoration: const BoxDecoration(
        color: Color(0xFF1C1C1E),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(18), bottomRight: Radius.circular(18)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 36, height: 4,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(3)),
          ),
          const SizedBox(width: 6),
          Container(
            width: 7, height: 7,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.3),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
          ),
        ],
      ),
    );
  }
}
