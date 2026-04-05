// lib/models/item_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  final String id;
  final String name;
  final String collection;
  final double price;

  /// Up to 5 image URLs. First element is the cover image shown in cards.
  final List<String> imageUrls;
  final List<String> tags;
  final double shippingCost;

  /// UID of the seller who owns this product (null = admin-seeded item).
  final String? sellerId;
  final bool isSold;

  ItemModel({
    required this.id,
    required this.name,
    required this.collection,
    required this.price,
    required this.imageUrls,
    required this.tags,
    required this.shippingCost,
    this.sellerId,
    this.isSold = false,
  });

  /// Convenience getter for the primary/cover image URL.
  String get imageUrl => imageUrls.isNotEmpty ? imageUrls.first : '';

  /// สร้าง ItemModel จาก Firestore document
  factory ItemModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ItemModel.fromMap(doc.id, data);
  }

  /// สร้าง ItemModel จาก Map (ใช้โดย FavoritesProvider)
  factory ItemModel.fromMap(String id, Map<String, dynamic> data) {
    // ── imageUrls: supports new array field, or legacy imageUrl string ──
    // Legacy formats handled:
    //   - "[url1, url2]"      (bracket-wrapped, comma-separated)
    //   - "url1, url2"        (plain comma-separated, split on ", https://")
    //   - "url"               (single URL)
    List<String> imageUrls = [];
    if (data['imageUrls'] != null) {
      imageUrls = List<String>.from(data['imageUrls'] as List);
    } else if (data['imageUrl'] != null &&
        (data['imageUrl'] as String).isNotEmpty) {
      var raw = (data['imageUrl'] as String).trim();
      // Strip outer [ ] if present
      if (raw.startsWith('[') && raw.endsWith(']')) {
        raw = raw.substring(1, raw.length - 1).trim();
      }
      // URLs are separated by ", https://" — avoid splitting inside URL params
      imageUrls = raw
          .split(RegExp(r',\s*(?=https://)'))
          .map((u) => u.trim())
          .where((u) => u.isNotEmpty)
          .toList();
    }

    // ── tags: supports new array field, or legacy condition string ──
    // Legacy formats handled:
    //   - "[tag1] + [tag2]"   (bracket-wrapped with + separator)
    //   - "tag1, tag2"        (plain comma-separated)
    //   - "tag"               (single value)
    List<String> tags = [];
    if (data['tags'] != null) {
      tags = List<String>.from(data['tags'] as List);
    } else if (data['condition'] != null &&
        (data['condition'] as String).isNotEmpty) {
      final raw = (data['condition'] as String).trim();
      if (raw.contains('[')) {
        // Extract content inside each [...]
        final matches = RegExp(r'\[([^\]]+)\]').allMatches(raw);
        tags = matches
            .map((m) => m.group(1)!.trim())
            .where((t) => t.isNotEmpty)
            .toList();
      } else {
        // Plain comma-separated
        tags = raw
            .split(',')
            .map((t) => t.trim())
            .where((t) => t.isNotEmpty)
            .toList();
      }
    }

    return ItemModel(
      id: id,
      name: data['name'] ?? '',
      collection: data['collection'] ?? '',
      price: _toDouble(data['price']),
      imageUrls: imageUrls,
      tags: tags,
      shippingCost: _toDouble(data['shippingCost']),
      sellerId: data['sellerId'] as String?,
      isSold: data['isSold'] as bool? ?? false,
    );
  }

  /// Safely converts a Firestore value to double.
  /// Handles num (int/double) and String values gracefully.
  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  /// แปลง ItemModel เป็น Map สำหรับเขียนลง Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'collection': collection,
      'price': price,
      'imageUrls': imageUrls,
      'tags': tags,
      'shippingCost': shippingCost,
      'isSold': isSold,
      if (sellerId != null) 'sellerId': sellerId,
    };
  }
}
