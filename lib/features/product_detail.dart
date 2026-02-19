// lib/features/product_detail.dart
import 'package:flutter/material.dart';
import '../models/item_model.dart'; // Import Model เพื่อมารับข้อมูล
import 'orders.dart'; // 1. Import หน้า orders เข้ามา

class ProductDetailScreen extends StatelessWidget {
  final ItemModel item;

  const ProductDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายละเอียดสินค้า'),
        backgroundColor: Colors.purple.shade50,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 350,
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
                    ),
              ),
            ),
            
            // 2. ข้อมูลสินค้า
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ชื่อสินค้า
                  Text(
                    item.name,
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  
                  // ราคาสินค้า
                  Text(
                    '${item.price} THB',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange),
                  ),
                  
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 10),
                  
                  // หมวดหมู่รายละเอียดต่างๆ
                  _buildDetailRow('คอลเลกชัน (Collection):', item.collection),
                  _buildDetailRow('สภาพสินค้า (Condition):', item.condition),
                  _buildDetailRow('ค่าจัดส่งโดยประมาณ:', '${item.shippingCost} THB'),
                  
                  const SizedBox(height: 20),
                  
                  // คำอธิบายเพิ่มเติม
                  const Text(
                    'รายละเอียดเพิ่มเติม',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'สินค้าลิขสิทธิ์แท้ 100% จัดส่งผ่านระบบคนกลาง (Escrow) เพื่อความปลอดภัยสูงสุด เงินของคุณจะถูกโอนให้ผู้ขายเมื่อคุณได้รับและตรวจสอบสินค้าเรียบร้อยแล้วเท่านั้น',
                    style: TextStyle(color: Colors.black54, height: 1.5),
                  ),
                  const SizedBox(height: 40), // เผื่อพื้นที่ด้านล่าง
                ],
              ),
            ),
          ],
        ),
      ),
      
      // 3. ปุ่มกดซื้อสินค้า 
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
            ),
            onPressed: () {
              // 2. เปลี่ยนให้เป็นการ Navigate ไปหน้า OrdersScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OrdersScreen()),
              );
            },
            child: const Text(
              'ซื้อสินค้า (ระบบคนกลาง Escrow)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  // Widget ตัวช่วยสำหรับสร้างแถวรายละเอียดซ้าย-ขวา
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 16)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}