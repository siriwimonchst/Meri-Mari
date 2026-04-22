import 'package:flutter/material.dart';
import 'landing_helpers.dart';

class LandingAbout extends StatelessWidget {
  final bool isDesktop;
  final GlobalKey sectionKey;

  const LandingAbout({super.key, required this.isDesktop, required this.sectionKey});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: sectionKey,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 100 : 20, vertical: 100),
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 5, child: _buildLogoCard()),
                const SizedBox(width: 80),
                Expanded(flex: 7, child: _buildAboutContent()),
              ],
            )
          : Column(
              children: [
                _buildMobileLogoCard(),
                const SizedBox(height: 40),
                _buildAboutContent(),
              ],
            ),
    );
  }

  Widget _buildLogoCard() {
    return Container(
      height: 450,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [LandingColors.mPurple.withOpacity(0.08), LandingColors.mAccent.withOpacity(0.15)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset('assets/last_logo.png', width: 120, height: 120, fit: BoxFit.cover),
            ),
            const SizedBox(height: 25),
            Text('Meri Mari', style: poppins(fontSize: 36, fontWeight: FontWeight.w900, color: const Color.fromARGB(255, 0, 0, 0))),
            const SizedBox(height: 8),
            Text('ตลาดมือสองคุณภาพ', style: poppins(fontSize: 18, color: LandingColors.mSubText, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLogoCard() {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [LandingColors.mPurple.withOpacity(0.08), LandingColors.mAccent.withOpacity(0.15)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Image.asset('assets/last_logo.png', width: 100, height: 100, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildAboutContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildBadge('About Us'),
        const SizedBox(height: 20),
        Text('About Meri Mari', style: poppins(fontSize: 42, fontWeight: FontWeight.w900, height: 1.2)),
        const SizedBox(height: 25),
        Text(
          'Meri-Mari คือแพลตฟอร์มตลาดมือสองระดับพรีเมียม ที่เชื่อมต่อผู้ซื้อและผู้ขายสินค้ามือสองคุณภาพ ของสะสม และไอเทมหายาก ด้วยระบบการตรวจสอบของแท้ 100% และการคุ้มครองผู้ซื้อผ่าน Escrow',
          style: poppins(fontSize: 18, color: LandingColors.mSubText, height: 1.8),
        ),
        const SizedBox(height: 30),
        _featureRow(Icons.verified_rounded, 'ตรวจสอบของแท้ 100%', 'ทีมผู้เชี่ยวชาญตรวจสอบสินค้าทุกชิ้นก่อนส่งถึงมือผู้ซื้อ'),
        const SizedBox(height: 20),
        _featureRow(Icons.security_rounded, 'ระบบ Escrow ปลอดภัย', 'เงินจะถูกส่งให้ผู้ขายเมื่อผู้ซื้อยืนยันการรับสินค้าเท่านั้น'),
        const SizedBox(height: 20),
        _featureRow(Icons.people_rounded, 'ชุมชนนักสะสม', 'เข้าร่วมชุมชนผู้ขายที่ได้รับการยืนยันกว่า 10,000+ ราย'),
        const SizedBox(height: 20),
        _featureRow(Icons.local_shipping_rounded, 'จัดส่งทั่วประเทศ', 'ระบบจัดส่งที่รวดเร็วและปลอดภัย พร้อมติดตามสถานะแบบเรียลไทม์'),
      ],
    );
  }

  Widget _featureRow(IconData icon, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: LandingColors.mPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: LandingColors.mPurple, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: poppins(fontWeight: FontWeight.w800, fontSize: 17)),
              const SizedBox(height: 4),
              Text(desc, style: poppins(color: LandingColors.mSubText, fontSize: 15, height: 1.5)),
            ],
          ),
        ),
      ],
    );
  }
}
