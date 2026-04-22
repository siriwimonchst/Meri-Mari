import 'package:flutter/material.dart';
import 'landing_helpers.dart';

class LandingTestimonials extends StatelessWidget {
  final bool isDesktop;

  const LandingTestimonials({super.key, required this.isDesktop});

  static const _testimonials = [
    {
      'quote': 'ซื้อ Art Toy หายากได้จาก Meri-Mari ระบบ Escrow ทำให้มั่นใจมาก สินค้าของแท้ 100% คุณภาพเกินคาด!',
      'name': 'Pream',
      'role': 'Premium Collector',
    },
    {
      'quote': 'เปิดร้านบน Meri-Mari ขายโมเดลมือสอง ระบบใช้ง่าย มีคนซื้อเยอะ รายได้ดีมากค่ะ แนะนำเลย!',
      'name': 'Mint',
      'role': 'Top Seller',
    },
    {
      'quote': 'ชอบระบบติดตามคำสั่งซื้อ ดูสถานะได้ตลอด จัดส่งเร็ว แพ็คของดี ไม่เสียหายเลย ใช้มาหลายครั้งแล้ว!',
      'name': 'Bank',
      'role': 'Verified Buyer',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            LandingColors.mPurple.withOpacity(0.03),
            LandingColors.mAccent.withOpacity(0.08),
            LandingColors.mPurple.withOpacity(0.03),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 100 : 20, vertical: 100),
      child: Column(
        children: [
          buildBadge('Testimonials'),
          const SizedBox(height: 20),
          Text(
            'What Our Users Say',
            style: poppins(fontSize: 42, fontWeight: FontWeight.w900, height: 1.2),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Text(
            'เสียงจากผู้ใช้จริงที่ไว้วางใจ Meri-Mari',
            style: poppins(fontSize: 18, color: LandingColors.mSubText),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),
          isDesktop
              ? Row(
                  children: _testimonials
                      .map((t) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: _buildCard(t),
                            ),
                          ))
                      .toList(),
                )
              : Column(
                  children: _testimonials
                      .map((t) => Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: _buildCard(t),
                          ))
                      .toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildCard(Map<String, String> data) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: LandingColors.mPurpleLight.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(color: LandingColors.mPurple.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: List.generate(5, (_) => Icon(Icons.star_rounded, color: Colors.amber.shade400, size: 20))),
          const SizedBox(height: 20),
          Text('"${data['quote']}"', style: poppins(fontSize: 16, height: 1.7, fontStyle: FontStyle.italic)),
          const SizedBox(height: 28),
          Container(height: 1, color: LandingColors.mPurpleLight.withOpacity(0.4)),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [LandingColors.mPurple, LandingColors.mAccent]),
                  shape: BoxShape.circle,
                ),
                child: const Center(child: Icon(Icons.person_rounded, color: Colors.white, size: 26)),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data['name']!, style: poppins(fontSize: 16, fontWeight: FontWeight.w700)),
                  Text(data['role']!, style: poppins(fontSize: 13, fontWeight: FontWeight.w500, color: LandingColors.mPurple)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
