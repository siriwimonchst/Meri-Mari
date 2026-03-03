// lib/features/account_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../providers/app_locale_provider.dart';

const _kPurple = Color(0xFF7B5EA7);
const _kText = Color(0xFF1A1A2E);
const _kSubText = Color(0xFF9E9E9E);

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  User? _user;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      _nameController.text = _user?.displayName ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    if (_user == null) return;

    setState(() => _isLoading = true);
    try {
      await _user!.updateDisplayName(_nameController.text.trim());
      // Reload the user to ensure auth state reflects changes immediately
      await _user!.reload();
      if (!mounted) return;

      final scaffoldMessenger = ScaffoldMessenger.of(context);
      final s = context.read<AppLocaleProvider>().strings;

      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(
            s.isThai ? 'บันทึกข้อมูลสำเร็จ' : 'Profile updated successfully',
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context); // Go back once done
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating profile: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _uploadPicture() async {
    // In a real app with Firebase Storage, you'd use image_picker here.
    // Since Firebase Storage might not be configured, we just show a mockup or URL update.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Upload profile picture feature is pending storage configuration.',
        ),
        backgroundColor: Colors.orange,
      ),
    );
  }

  Future<void> _deletePicture() async {
    if (_user == null) return;

    setState(() => _isLoading = true);
    try {
      await _user!.updatePhotoURL(null);
      await _user!.reload();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile picture removed'),
          backgroundColor: Colors.green,
        ),
      );
      setState(() {
        _user = FirebaseAuth.instance.currentUser;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error removing picture: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Account')),
        body: const Center(child: Text('Not logged in')),
      );
    }

    final s = context.watch<AppLocaleProvider>().strings;
    final photoUrl = _user?.photoURL;
    final email = _user?.email ?? '-';
    final currentDisplayName = _user?.displayName ?? '';
    final avatarLetter = currentDisplayName.isNotEmpty
        ? currentDisplayName[0].toUpperCase()
        : (email.isNotEmpty ? email[0].toUpperCase() : '?');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leadingWidth: 40,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: _kPurple,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          s.account,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: _kText,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: _kPurple))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Area 1: Avatar / Photo Management
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFEDE7F6),
                              border: Border.all(
                                color: const Color(0xFFD4C8E8),
                                width: 2,
                              ),
                              image: photoUrl != null
                                  ? DecorationImage(
                                      image: NetworkImage(photoUrl),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: photoUrl == null
                                ? Center(
                                    child: Text(
                                      avatarLetter,
                                      style: const TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.w800,
                                        color: _kPurple,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton.icon(
                                onPressed: _uploadPicture,
                                icon: const Icon(
                                  Icons.upload_rounded,
                                  size: 18,
                                ),
                                label: Text(s.isThai ? 'อัปโหลดรูป' : 'Upload'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: _kPurple,
                                  side: const BorderSide(color: _kPurple),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              if (photoUrl != null)
                                OutlinedButton.icon(
                                  onPressed: _deletePicture,
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                    size: 18,
                                  ),
                                  label: Text(s.isThai ? 'ลบรูป' : 'Remove'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.red.shade400,
                                    side: BorderSide(
                                      color: Colors.red.shade200,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 48),

                    // Area 2: Display Name Editing
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.isThai ? 'ชื่อผู้ใช้' : 'Display Name',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _kSubText,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: _kPurple,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return s.isThai
                                  ? 'กรุณากรอกชื่อผู้ใช้'
                                  : 'Please enter a name';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 24),

                        Text(
                          s.isThai
                              ? 'อีเมล (ไม่สามารถแก้ไขได้)'
                              : 'Email (Cannot be modified)',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _kSubText,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          initialValue: email,
                          enabled: false,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            fillColor: Colors.grey.shade100,
                            filled: true,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 48),

                    // Area 3: Save button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _updateProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _kPurple,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          s.isThai ? 'บันทึกการเปลี่ยนแปลง' : 'Save Changes',
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
            ),
    );
  }
}
