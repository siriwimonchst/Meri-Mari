import 'package:flutter/material.dart';
import 'landing_helpers.dart';

class LandingNavbar extends StatelessWidget {
  final bool isDesktop;
  final VoidCallback onFeaturesTap;
  final VoidCallback onAboutTap;

  const LandingNavbar({
    super.key,
    required this.isDesktop,
    required this.onFeaturesTap,
    required this.onAboutTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white.withOpacity(0.9),
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 80 : 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset('assets/last_logo.png', width: 38, height: 38, fit: BoxFit.cover),
              ),
              const SizedBox(width: 12),
              Text('Meri Mari', style: poppins(fontSize: 24, fontWeight: FontWeight.w900)),
            ],
          ),
          if (isDesktop)
            Row(
              children: [
                _navLink('Features', onFeaturesTap),
                _navLink('About', onAboutTap),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: LandingColors.mPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    elevation: 0,
                  ),
                  child: Text('Launch App', style: poppins(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
                ),
              ],
            )
          else
            const Icon(Icons.menu_rounded, color: LandingColors.mText, size: 30),
        ],
      ),
    );
  }

  Widget _navLink(String text, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Text(text, style: poppins(color: LandingColors.mSubText, fontWeight: FontWeight.w600, fontSize: 16)),
        ),
      ),
    );
  }
}
