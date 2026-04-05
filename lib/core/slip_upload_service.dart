import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io' as io;

/// Possible states of a payment slip.
enum SlipStatus {
  pending,   // uploaded, waiting for admin review
  approved,  // admin approved
  rejected,  // admin rejected
}

extension SlipStatusJson on SlipStatus {
  String toJson() => name;
  static SlipStatus fromJson(String s) =>
      SlipStatus.values.firstWhere((e) => e.name == s, orElse: () => SlipStatus.pending);
}

class SlipUploadService {
  SlipUploadService._();
  static final SlipUploadService instance = SlipUploadService._();

  final _db = FirebaseFirestore.instance;

  /// Converts an image to a Base64 Data URL and records it in Firestore.
  /// (No external storage used, purely Firestore).
  Future<String> uploadSlip({
    io.File? slipFile,
    Uint8List? slipBytes,
    required String orderId,
    void Function(double progress)? onProgress,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw StateError('No authenticated user');

    if (slipFile == null && slipBytes == null) {
      throw ArgumentError('Either slipFile or slipBytes must be provided');
    }

    onProgress?.call(0.2); // Start

    // ── 1. Convert to Base64 ──────────────────────────────────────────────
    Uint8List finalBytes;
    if (kIsWeb && slipBytes != null) {
      finalBytes = slipBytes;
    } else if (slipFile != null) {
      finalBytes = await slipFile.readAsBytes();
    } else if (slipBytes != null) {
      finalBytes = slipBytes;
    } else {
      throw StateError('Invalid state for conversion');
    }

    onProgress?.call(0.5); // Halfway

    final base64String = base64Encode(finalBytes);
    final dataUrl = 'data:image/jpeg;base64,$base64String';

    onProgress?.call(0.8); // Almost there (Saving to DB)

    // ── 2. Update Firestore order document ────────────────────────────────
    await _db
        .collection('users')
        .doc(uid)
        .collection('orders')
        .doc(orderId)
        .update({
      'slipUrl':    dataUrl,
      'slipStatus': SlipStatus.pending.toJson(),
      'slipUploadedAt': FieldValue.serverTimestamp(),
      'hasSlip':    true,
    });

    onProgress?.call(1.0); // Done
    return dataUrl;
  }
}
