// lib/features/product_detail.dart
import 'package:flutter/material.dart';
import '../models/item_model.dart'; 
import 'orders.dart'; 

class ProductDetailScreen extends StatelessWidget {
  final ItemModel item;

  const ProductDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // 1. ทำให้หน้าจอขยายไปสุดขอบบน (ใต้ AppBar โปร่งใส)
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // ปุ่มย้อนกลับแบบวงกลม เพื่อให้มองเห็นชัดเจนบนรูปภาพ
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.9),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.deepPurple.shade800, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // 2. รูปภาพสินค้า (อยู่ด้านหลังสุด)
            SizedBox(
              width: double.infinity,
              height: 420, // เพิ่มความสูงให้รูปดูอลังการขึ้น
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(
                      color: Colors.deepPurple.shade50,
                      child: Icon(Icons.image_not_supported_rounded, size: 80, color: Colors.deepPurple.shade200),
                    ),
              ),
            ),
            
            // 3. ส่วนข้อมูลสินค้า (ซ้อนทับรูปภาพและมีมุมโค้ง)
            Container(
              margin: const EdgeInsets.only(top: 380), // ขยับลงมาให้เห็นรูป และซ้อนทับรูป 40px
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)), // มุมโค้งด้านบน
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ชื่อสินค้าและราคา
                    Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 28, 
                        fontWeight: FontWeight.w800, 
                        color: Colors.deepPurple.shade900,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${item.price} THB',
                      style: const TextStyle(
                        fontSize: 24, 
                        fontWeight: FontWeight.bold, 
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 28),
                    
                    // 4. กล่องรายละเอียดสินค้า (ดีไซน์เป็นกล่องสีพาสเทล)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.deepPurple.withOpacity(0.1)),
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow('คอลเลกชัน (Collection)', item.collection),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Divider(color: Colors.deepPurple.withOpacity(0.15), height: 1),
                          ),
                          _buildDetailRow('สภาพสินค้า (Condition)', item.condition),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Divider(color: Colors.deepPurple.withOpacity(0.15), height: 1),
                          ),
                          _buildDetailRow('ค่าจัดส่งโดยประมาณ', '${item.shippingCost} THB'),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // 5. คำอธิบายเพิ่มเติม
                    Text(
                      'รายละเอียดเพิ่มเติม',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple.shade800),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'สินค้าลิขสิทธิ์แท้ 100% จัดส่งผ่านระบบคนกลาง (Escrow) เพื่อความปลอดภัยสูงสุด เงินของคุณจะถูกโอนให้ผู้ขายเมื่อคุณได้รับและตรวจสอบสินค้าเรียบร้อยแล้วเท่านั้น',
                      style: TextStyle(color: Colors.grey.shade600, height: 1.6, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      
      // 6. แถบปุ่มกดด้านล่าง (มีเงาบางๆ แยกส่วนจากเนื้อหา)
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 56, // ปรับปุ่มให้สูงกำลังดี
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple.shade600,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OrdersScreen()),
                );
              },
              child: const Text(
                'ซื้อสินค้า (ระบบคนกลาง Escrow)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget ตัวช่วยสำหรับสร้างแถวรายละเอียดซ้าย-ขวา ให้ดูสะอาดตา
  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label, 
          style: TextStyle(color: Colors.deepPurple.shade300, fontSize: 14, fontWeight: FontWeight.w600)
        ),
        Text(
          value, 
          style: TextStyle(color: Colors.deepPurple.shade800, fontWeight: FontWeight.bold, fontSize: 15)
        ),
      ],
    );
  }
}