import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../providers/app_locale_provider.dart';
import '../core/app_theme.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isLoading = false;
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) return;

    setState(() => _isLoading = true);
    final s = context.read<AppLocaleProvider>().strings;

    try {
      // 1. Re-authenticate
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: _currentController.text.trim(),
      );
      await user.reauthenticateWithCredential(cred);

      // 2. Update Password
      await user.updatePassword(_newController.text.trim());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(s.passwordChangedSuccess),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      String msg = e.message ?? 'An error occurred';
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        msg = s.wrongCurrentPassword;
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: kErrorRed),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: kErrorRed),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppLocaleProvider>().strings;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kPurple),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          s.changePassword,
          style: const TextStyle(fontWeight: FontWeight.w800, color: kText),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: kPurple))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildField(
                      controller: _currentController,
                      label: s.currentPassword,
                      obscure: _obscureCurrent,
                      onToggleObscure: () => setState(() => _obscureCurrent = !_obscureCurrent),
                    ),
                    const SizedBox(height: 20),
                    _buildField(
                      controller: _newController,
                      label: s.newPassword,
                      obscure: _obscureNew,
                      onToggleObscure: () => setState(() => _obscureNew = !_obscureNew),
                    ),
                    const SizedBox(height: 20),
                    _buildField(
                      controller: _confirmController,
                      label: s.confirmNewPassword,
                      obscure: _obscureConfirm,
                      onToggleObscure: () => setState(() => _obscureConfirm = !_obscureConfirm),
                      validator: (v) {
                        if (v == null || v.isEmpty) return s.fieldRequired;
                        if (v != _newController.text) return s.passwordMismatch;
                        return null;
                      },
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _updatePassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPurple,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Text(
                          s.save,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback onToggleObscure,
    String? Function(String?)? validator,
  }) {
    final s = context.read<AppLocaleProvider>().strings;
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator ?? (v) => (v == null || v.isEmpty) ? s.fieldRequired : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: kPurpleLight, fontSize: 13),
        filled: true,
        fillColor: kPurpleFaint,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: kPurpleBorder)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: kPurpleBorder)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: kPurple, width: 2)),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20, color: Colors.grey),
          onPressed: onToggleObscure,
        ),
      ),
    );
  }
}
