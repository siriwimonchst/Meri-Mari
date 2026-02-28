// lib/models/item_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  final String id;
  final String name;
  final String collection;
  final double price;
  final String imageUrl;
  final String condition;
  final double shippingCost;

  ItemModel({
    required this.id,
    required this.name,
    required this.collection,
    required this.price,
    required this.imageUrl,
    required this.condition,
    required this.shippingCost,
  });

  /// สร้าง ItemModel จาก Firestore document
  factory ItemModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ItemModel(
      id: doc.id,
      name: data['name'] ?? '',
      collection: data['collection'] ?? '',
      price: (data['price'] as num).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      condition: data['condition'] ?? '',
      shippingCost: (data['shippingCost'] as num).toDouble(),
    );
  }

  /// แปลง ItemModel เป็น Map สำหรับเขียนลง Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'collection': collection,
      'price': price,
      'imageUrl': imageUrl,
      'condition': condition,
      'shippingCost': shippingCost,
    };
  }
}
