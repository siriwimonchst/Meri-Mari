// lib/providers/address_provider.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/address_service.dart';
import '../models/address_model.dart';

/// Exposes the current user's default address as a reactive stream.
/// Used by the home screen location bar and any other place needing the
/// current delivery address.
class AddressProvider extends ChangeNotifier {
  final AddressService _service = AddressService();

  AddressModel? _defaultAddress;
  AddressModel? get defaultAddress => _defaultAddress;

  /// Short display string for the location bar.
  String get locationSummary {
    if (_defaultAddress == null) return '';
    final a = _defaultAddress!;
    final parts = <String>[
      if (a.addressLine1.isNotEmpty) a.addressLine1,
      if (a.city.isNotEmpty) a.city,
    ];
    return parts.join(', ');
  }

  AddressProvider() {
    // Listen to auth state changes so we reload when the user logs in/out.
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _listenToAddresses();
      } else {
        _defaultAddress = null;
        notifyListeners();
      }
    });
  }

  void _listenToAddresses() {
    _service.streamAddresses().listen((addresses) {
      _defaultAddress = addresses.where((a) => a.isDefault).firstOrNull;
      notifyListeners();
    });
  }
}
