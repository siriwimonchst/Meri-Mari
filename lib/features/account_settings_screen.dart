import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/app_locale_provider.dart';
import '../core/app_theme.dart';

const _kPurple = kPurple;
const _kText = kText;

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
      // Initial fetch to set name controller
      FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .get()
          .then((doc) {
        if (doc.exists && mounted) {
          final display = doc.data()?['displayName'];
          if (display != null) {
            _nameController.text = display;
          }
        }
      });
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
      final newName = _nameController.text.trim();
      await _user!.updateDisplayName(newName);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .set({'displayName': newName}, SetOptions(merge: true));

      await _user!.reload();
      if (!mounted) return;

      final s = context.read<AppLocaleProvider>().strings;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(s.isThai ? 'บันทึกข้อมูลสำเร็จ' : 'Profile updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _uploadPicture() async {
    if (_user == null) return;
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 400,
      maxHeight: 400,
      imageQuality: 50,
    );
    if (pickedFile == null) return;

    setState(() => _isLoading = true);
    try {
      final bytes = await pickedFile.readAsBytes();
      final dataUrl = 'data:image/jpeg;base64,${base64Encode(bytes)}';

      await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .set({'photoUrl': dataUrl}, SetOptions(merge: true));

      try { await _user!.updatePhotoURL(dataUrl); } catch (_) {}
      await _user!.reload();

      if (mounted) {
        final s = context.read<AppLocaleProvider>().strings;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(s.isThai ? 'อัปโหลดสำเร็จ' : 'Upload successful'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deletePicture() async {
    if (_user == null) return;
    setState(() => _isLoading = true);
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .update({'photoUrl': FieldValue.delete()});
      await _user!.updatePhotoURL(null);
      await _user!.reload();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) return const Scaffold(body: Center(child: Text('Please Log In')));
    final s = context.watch<AppLocaleProvider>().strings;

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('users').doc(_user!.uid).snapshots(),
      builder: (context, snapshot) {
        final data = snapshot.data?.data();
        final photoUrl = data?['photoUrl'] ?? _user?.photoURL;
        final displayName = data?['displayName'] ?? _user?.displayName ?? '';
        final avatarLetter = displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _kText, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(s.editProfile, style: const TextStyle(fontWeight: FontWeight.w800, color: _kText)),
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator(color: _kPurple))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFFEDE7F6),
                                  border: Border.all(color: const Color(0xFFD4C8E8), width: 2),
                                  image: photoUrl != null
                                      ? DecorationImage(
                                          image: photoUrl.startsWith('data:image')
                                              ? MemoryImage(base64Decode(photoUrl.split(',')[1])) as ImageProvider
                                              : NetworkImage(photoUrl),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                child: photoUrl == null
                                    ? Center(child: Text(avatarLetter, style: const TextStyle(fontSize: 40, color: _kPurple, fontWeight: FontWeight.w800)))
                                    : null,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  OutlinedButton.icon(
                                    onPressed: _uploadPicture,
                                    icon: const Icon(Icons.upload_rounded, size: 18),
                                    label: Text(s.isThai ? 'อัปโหลด' : 'Upload'),
                                    style: OutlinedButton.styleFrom(foregroundColor: _kPurple, side: const BorderSide(color: _kPurple)),
                                  ),
                                  if (photoUrl != null) ...[
                                    const SizedBox(width: 12),
                                    OutlinedButton.icon(
                                      onPressed: _deletePicture,
                                      icon: const Icon(Icons.delete_outline_rounded, size: 18),
                                      label: Text(s.isThai ? 'ลบ' : 'Delete'),
                                      style: OutlinedButton.styleFrom(foregroundColor: _kText),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: s.displayName,
                            labelStyle: const TextStyle(color: kPurpleLight, fontSize: 13),
                            filled: true,
                            fillColor: kPurpleFaint,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: kPurpleBorder)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: kPurpleBorder)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: kPurple, width: 2)),
                          ),
                          validator: (v) => (v == null || v.isEmpty) ? s.fieldRequired : null,
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _updateProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _kPurple,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            child: Text(s.saveChanges, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
