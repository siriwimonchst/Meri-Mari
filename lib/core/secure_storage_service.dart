// lib/core/secure_storage_service.dart
// ─── Encrypted On-Device Storage ─────────────────────────────────────────────
// Wraps flutter_secure_storage to provide a thin, testable API.
// On Android  : AES-256 via Android Keystore.
// On iOS/macOS: Keychain Services.
// On Windows  : DPAPI (Data Protection API).
// On Web      : localStorage — NOTE: not truly secure; avoid storing secrets on web.
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  // ── Singleton ──────────────────────────────────────────────────────────────
  SecureStorageService._();
  static final SecureStorageService instance = SecureStorageService._();

  // Android options: force AES-256 encryption via EncryptedSharedPreferences.
  static const _androidOptions = AndroidOptions(
    encryptedSharedPreferences: true,
  );

  static const _storage = FlutterSecureStorage(
    aOptions: _androidOptions,
  );

  // ── Keys ───────────────────────────────────────────────────────────────────
  static const _keyEmail    = 'meri_mari_saved_email';
  static const _keyPassword = 'meri_mari_saved_pass';

  // ── Remember-Me credentials ────────────────────────────────────────────────

  /// Persist email + password (called after successful login when Remember Me is on).
  Future<void> saveCredentials({
    required String email,
    required String password,
  }) async {
    await Future.wait([
      _storage.write(key: _keyEmail,    value: email),
      _storage.write(key: _keyPassword, value: password),
    ]);
  }

  /// Load previously saved credentials.
  /// Returns `null` if no credentials are stored.
  Future<({String email, String password})?> loadCredentials() async {
    final results = await Future.wait([
      _storage.read(key: _keyEmail),
      _storage.read(key: _keyPassword),
    ]);
    final email    = results[0];
    final password = results[1];
    if (email == null || password == null) return null;
    return (email: email, password: password);
  }

  /// Delete stored credentials (called when Remember Me is turned off or on logout).
  Future<void> clearCredentials() async {
    await Future.wait([
      _storage.delete(key: _keyEmail),
      _storage.delete(key: _keyPassword),
    ]);
  }

  /// Wipe every key managed by this app (use on full logout / account deletion).
  Future<void> clearAll() => _storage.deleteAll();
}
