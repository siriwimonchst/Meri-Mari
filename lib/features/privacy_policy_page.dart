import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_theme.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            _buildContent(context),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2D1B4E), kPurple],
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.description_outlined,
              size: 40,
              color: kPurple,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Privacy Policy & Terms of Service',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Last updated: April 2026',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 32),
          TextButton.icon(
            onPressed: () => Navigator.of(context).pushReplacementNamed('/landing-page'),
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
            label: Text(
              'Back to Home',
              style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              backgroundColor: Colors.white.withOpacity(0.1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 800),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        children: [
          _buildSection(
            '1. Information We Collect',
            'We collect information you provide directly, such as your name, email address, and profile photo when you create an account. We also collect usage data such as items you save to favorites, reviews you write, and delivery addresses provided for orders.',
          ),
          _buildSection(
            '2. How We Use Your Information',
            'We use the information we collect to provide, maintain, and improve Meri-Mari. This includes personalizing your experience, enabling community features, sending account-related notifications, and ensuring the security of our service.',
          ),
          _buildSection(
            '3. Data Storage & Security',
            'Your data is stored securely on Google Firebase servers. We implement industry-standard security measures including encrypted connections (TLS/SSL) and secure authentication. However, no method of transmission over the internet is 100% secure.',
          ),
          _buildSection(
            '4. Third-Party Services',
            'Meri-Mari utilizes Google Firebase for authentication, database management, and cloud storage. We may also use analytics services to understand how users interact with our application to improve our services.',
          ),
          _buildSection(
            '5. Data Sharing',
            'We do not sell or share your personal information with third parties for marketing purposes. Your information is only shared when necessary to provide our services (e.g., sharing delivery info with a seller) or when required by law.',
          ),
          _buildSection(
            '6. Your Rights',
            'You have the right to access, correct, or delete your personal information. You can manage your profile details directly within the app settings. You also have the right to request a copy of the data we hold about you.',
          ),
          _buildSection(
            '7. Children\'s Privacy',
            'Meri-Mari is not intended for use by children under the age of 13. We do not knowingly collect personal information from children under 13.',
          ),
          _buildSection(
            '8. Changes to This Policy',
            'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last updated" date.',
          ),
          _buildSection(
            '9. Contact Us',
            'If you have any questions about this Privacy Policy, please contact us at support@meri-mari.com',
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 5,
              decoration: const BoxDecoration(
                color: kPurple,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2D1B4E),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      content,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.black87,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Text(
        '© 2026 Meri-Mari. All rights reserved.',
        style: GoogleFonts.poppins(
          fontSize: 13,
          color: Colors.grey,
        ),
      ),
    );
  }
}
