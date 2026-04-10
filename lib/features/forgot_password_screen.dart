import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_locale_provider.dart';
import '../core/app_theme.dart';
import 'auth_widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  void _showDemoDialog() {
    final s = context.read<AppLocaleProvider>().strings;
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              child: Column(
                children: [
                  Text(
                    s.forgotPasswordTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: kText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    s.forgotPasswordDemoMsg,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: kText,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 1,
              color: Colors.grey.withValues(alpha: 0.15),
            ),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: TextButton(
                onPressed: () => Navigator.pop(ctx),
                style: TextButton.styleFrom(
                  foregroundColor: kPurple,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                ),
                child: Text(
                  s.okLabel,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final s = context.watch<AppLocaleProvider>().strings;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ── Background Gradient ───────────────────────────────────────
          Container(
            height: screenHeight * kAuthBgHeightRatio,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFC5B4E3), Color(0xFF8B73AF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // ── White Card Content ────────────────────────────────────────
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: screenHeight * kAuthCardHeightRatio,
              padding: const EdgeInsets.fromLTRB(28, 48, 28, 28),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Back Button
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kPurple),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Title
                    Text(
                      s.forgotPasswordTitle,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Description
                    Text(
                      s.enterEmailHint,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF757575),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Email field
                    AuthInputField(
                      controller: _emailCtrl,
                      hint: s.email,
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      autofocus: true,
                    ),
                    const SizedBox(height: 32),

                    // Send Button
                    AuthGradientButton(
                      label: s.sendResetLink,
                      onPressed: _showDemoDialog,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
