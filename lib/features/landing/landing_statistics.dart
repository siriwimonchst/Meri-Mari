import 'package:flutter/material.dart';
import 'landing_helpers.dart';

class LandingStatistics extends StatelessWidget {
  final bool isDesktop;

  const LandingStatistics({super.key, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 100 : 20, vertical: 100),
      child: Wrap(
        spacing: 80,
        runSpacing: 50,
        alignment: WrapAlignment.center,
        children: [
          _statItem(Icons.grid_view_rounded, '50,000+', 'Active Listings', LandingColors.mPurple),
          _statItem(Icons.verified_user_rounded, '10,000+', 'Verified Sellers', LandingColors.mPurple),
          _statItem(Icons.star_rounded, '4.9/5', 'Customer Satisfaction', LandingColors.mPurple),
        ],
      ),
    );
  }

  Widget _statItem(IconData icon, String val, String sub, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 35),
        ),
        const SizedBox(height: 20),
        Text(val, style: poppins(fontSize: 40, fontWeight: FontWeight.w900)),
        Text(sub, style: poppins(color: LandingColors.mSubText, fontSize: 15)),
      ],
    );
  }
}
