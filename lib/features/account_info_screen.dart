import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/app_locale_provider.dart';
import '../core/app_theme.dart';
import 'account_settings_screen.dart';

class AccountInfoScreen extends StatelessWidget {
  const AccountInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final s = context.watch<AppLocaleProvider>().strings;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text(s.accountInfo)),
        body: const Center(child: Text('User not found')),
      );
    }

    final createdAt = user.metadata.creationTime;
    final formattedDate = createdAt != null 
        ? "${createdAt.day}/${createdAt.month}/${createdAt.year}" 
        : "-";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kText, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          s.accountInfo,
          style: const TextStyle(fontWeight: FontWeight.w800, color: kText),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AccountSettingsScreen())),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1)),
                ),
                child: Row(
                  children: [
                    Text(
                      s.profile,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: kText,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              context,
              label: s.email,
              value: user.email ?? '-',
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              context,
              label: s.accountCreated,
              value: formattedDate,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, {
    required String label,
    required String value,
    bool canCopy = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kPurpleFaint,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kPurpleBorder, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: kPurple,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: kText,
                  ),
                ),
              ),
              if (canCopy)
                IconButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: value));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Copied to clipboard'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  icon: const Icon(Icons.copy_rounded, size: 20, color: kPurpleLight),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
