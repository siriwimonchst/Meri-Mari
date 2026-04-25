import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_theme.dart';

class DeleteAccountPage extends StatelessWidget {
  const DeleteAccountPage({super.key});

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
              Icons.person_remove_outlined,
              size: 40,
              color: kPurple,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Account Deletion Request',
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
            '1. How to Delete Your Account',
            'You can request account deletion directly within the Meri-Mari app. Go to Profile > Settings > Request Account Deletion. You will be asked to confirm your choice before the process begins.',
          ),
          _buildSection(
            '2. What Gets Deleted',
            'When you delete your account, the following data will be permanently removed: your personal profile information (name, email, photo), saved delivery addresses, and your favorites list. Any active sessions will be terminated.',
          ),
          _buildSection(
            '3. What Gets Retained',
            'Some information may be retained for a limited period (typically 30 days) for security purposes or to comply with legal obligations. This includes transaction history related to orders and financial records as required by local regulations.',
          ),
          _buildSection(
            '4. Timeframe for Deletion',
            'Account deletion takes effect immediately upon confirmation for your profile visibility. However, full data erasure from our backups may take up to 30 days. Once deleted, an account cannot be recovered.',
          ),
          _buildSection(
            '5. Need Assistance?',
            'If you have trouble deleting your account through the app or have questions about the process, please contact our support team at support@meri-mari.com with your registered email address.',
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
