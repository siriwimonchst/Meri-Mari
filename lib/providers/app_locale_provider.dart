// lib/providers/app_locale_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_strings.dart';

class AppLocaleProvider extends ChangeNotifier {
  static const _key = 'locale_is_thai';
  bool _isThai = false;

  bool get isThai => _isThai;
  AppStrings get strings => AppStrings(isThai: _isThai);

  AppLocaleProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _isThai = prefs.getBool(_key) ?? false;
    notifyListeners();
  }

  Future<void> toggle() async {
    _isThai = !_isThai;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, _isThai);
  }
}
