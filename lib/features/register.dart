import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/app_locale_provider.dart';
import '../core/app_theme.dart';
import 'auth_widgets.dart';
import 'main_screen.dart';
import 'auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;
  bool _obscure = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text.trim();

    if (name.isEmpty || email.isEmpty || pass.isEmpty) {
      final s = context.read<AppLocaleProvider>().strings;
      _showError(s.isThai ? 'กรุณากรอกข้อมูลให้ครบถ้วน' : 'Please fill in all fields');
      return;
    }
    if (pass.length < 6) {
      final s = context.read<AppLocaleProvider>().strings;
      _showError(s.isThai ? 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร' : 'Password must be at least 6 characters');
      return;
    }

    setState(() => _loading = true);
    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );
      await cred.user?.updateDisplayName(name);
      if (!mounted) return;
      await _afterSignUp();
    } on FirebaseAuthException catch (e) {
      String msg;
      switch (e.code) {
        case 'email-already-in-use':
          msg = 'อีเมลนี้ถูกใช้งานแล้ว';
          break;
        case 'invalid-email':
          msg = 'รูปแบบอีเมลไม่ถูกต้อง';
          break;
        case 'weak-password':
          msg = 'รหัสผ่านง่ายเกินไป';
          break;
        default:
          msg = 'เกิดข้อผิดพลาด: ${e.message}';
      }
      _showError(msg);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _afterSignUp() async {
    await context.read<FavoritesProvider>().loadFavorites();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
      (_) => false,
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: const Color(0xFFC62828),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

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
            // Pattern overlay simulating the circular lines from the design
            child: Stack(
              children: [
                Positioned(
                  top: kDecorOuterOffset,
                  right: kDecorOuterOffset,
                  child: Container(
                    width: kDecorOuterSize,
                    height: kDecorOuterSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: kDecorBorderAlpha),
                        width: 1,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: kDecorMidOffset,
                  right: kDecorMidOffset,
                  child: Container(
                    width: kDecorMidSize,
                    height: kDecorMidSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: kDecorBorderAlpha),
                        width: 1,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: kDecorInnerOffset,
                  right: kDecorInnerOffset,
                  child: Container(
                    width: kDecorInnerSize,
                    height: kDecorInnerSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: kDecorBorderAlpha),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Back Arrow (Top Left) ───────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: Builder(
                  builder: (context) {
                    final s = context.watch<AppLocaleProvider>().strings;
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 18,
                          color: Color(0xFF1A1A2E),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          s.isThai ? 'กลับ' : 'Back',
                          style: const TextStyle(fontSize: 15, color: Color(0xFF1A1A2E)),
                        ),
                      ],
                    );
                  },
                ),
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
              child: Builder(
                builder: (context) {
                  final s = context.watch<AppLocaleProvider>().strings;
                  return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Title
                    Text(
                      s.isThai ? 'สร้างบัญชีของคุณ' : 'Create Your Account',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Catchy Phrase
                    Text(
                      s.isThai
                          ? 'เข้าร่วมชุมชน Meri Mari วันนี้\nและค้นพบสิ่งที่คุณชื่นชอบ!'
                          : 'Join the Meri Mari community today\nand discover what you love!',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF757575),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Name
                    AuthInputField(
                      controller: _nameCtrl,
                      hint: s.isThai ? 'กรอกชื่อ-นามสกุล' : 'Enter full name',
                      icon: Icons.person_outline_rounded,
                    ),
                    const SizedBox(height: 16),

                    // Email
                    AuthInputField(
                      controller: _emailCtrl,
                      hint: s.isThai ? 'กรอกอีเมล' : 'Enter email',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),

                    // Password
                    AuthInputField(
                      controller: _passCtrl,
                      hint: s.isThai ? 'กรอกรหัสผ่าน' : 'Enter password',
                      icon: Icons.lock_outline,
                      obscure: _obscure,
                      suffix: IconButton(
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20,
                          color: const Color(0xFFAB9DC4),
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                      onSubmitted: (_) => _register(),
                    ),
                    const SizedBox(height: 32),

                    // Sign Up Button (Gradient)
                    AuthGradientButton(
                      label: s.isThai ? 'เริ่มต้นใช้งาน' : 'Get Started',
                      loading: _loading,
                      onPressed: _register,
                    ),

                    const SizedBox(height: 24),

                    // Sign in link
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const AuthScreen()),
                      ),
                      child: RichText(
                        text: TextSpan(
                          text: s.alreadyHaveAccount,
                          style: const TextStyle(
                            color: Color(0xFF757575),
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(
                              text: s.login,
                              style: const TextStyle(
                                color: Color(0xFF7B5EA7),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
