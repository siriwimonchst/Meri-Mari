// lib/features/language_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../providers/app_locale_provider.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  late bool _isThai;

  @override
  void initState() {
    super.initState();
    _isThai = context.read<AppLocaleProvider>().isThai;
  }

  void _onDone() {
    final provider = context.read<AppLocaleProvider>();
    if (provider.isThai != _isThai) {
      provider.toggle();
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppLocaleProvider>().strings;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kText, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          s.selectLanguage,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: kText,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _onDone,
            child: Text(
              s.okLabel,
              style: const TextStyle(
                color: kPurple,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        children: [
          _buildHeader(s.defaultLanguageSection),
          _buildOption(
            label: 'ไทย',
            isSelected: _isThai,
            onTap: () => setState(() => _isThai = true),
          ),
          _buildHeader(s.otherLanguagesSection, subtitle: s.otherLanguagesHint),
          _buildOption(
            label: 'English',
            isSelected: !_isThai,
            onTap: () => setState(() => _isThai = false),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String title, {String? subtitle}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOption({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Color(0xFFF0EAF8), width: 1),
          ),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? kPurple : kText,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_rounded, color: kPurple, size: 24),
          ],
        ),
      ),
    );
  }
}
