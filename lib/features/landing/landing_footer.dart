import 'package:flutter/material.dart';
import 'landing_helpers.dart';

class LandingFooter extends StatelessWidget {
  final bool isDesktop;

  const LandingFooter({super.key, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 100 : 20, vertical: 100),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Meri-Mari', style: poppins(fontSize: 32, fontWeight: FontWeight.w900, color: LandingColors.mPurple)),
                  const SizedBox(height: 20),
                  Text(
                    'Premium Marketplace for\nCollectibles & Second-hand goods.',
                    style: poppins(color: LandingColors.mSubText, height: 1.6),
                  ),
                ],
              ),
              if (isDesktop) ...[
                _footerCol('Categories', ['Art Toys', 'Models', 'Cards', 'Accessories']),
                _footerCol('For Sellers', ['Start Selling', 'Seller Policy', 'Fees']),
                _footerCol('Support', ['How to Buy', 'Refund Policy', 'Contact Us']),
              ],
            ],
          ),
          const SizedBox(height: 80),
          const Divider(color: Color(0xFFF2F2F7)),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('© 2026 Meri-Mari Market. All rights reserved.', style: poppins(color: LandingColors.mSubText, fontSize: 14)),
              Row(
                children: [
                  Icon(Icons.facebook, color: LandingColors.mSubText),
                  const SizedBox(width: 25),
                  Icon(Icons.camera_alt_outlined, color: LandingColors.mSubText),
                  const SizedBox(width: 25),
                  Icon(Icons.message_outlined, color: LandingColors.mSubText),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _footerCol(String t, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(t, style: poppins(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 25),
        ...items.map((i) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(i, style: poppins(color: LandingColors.mSubText)),
            )),
      ],
    );
  }
}
