// lib/features/orders.dart
import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data 
    final List<Map<String, dynamic>> mockOrders = [
      {
        'id': 'ORD-001',
        'itemName': 'Hirono V1 - Fox',
        'price': 350.0,
        'status': 'รอผู้ซื้อชำระเงิน',
        'statusColor': Colors.orange,
      },
      {
        'id': 'ORD-002',
        'itemName': 'Crybaby Bunny',
        'price': 590.0,
        'status': 'ผู้ขายกำลังจัดส่ง',
        'statusColor': Colors.blue,
      },
      {
        'id': 'ORD-003',
        'itemName': 'Labubu Macaron',
        'price': 890.0,
        'status': 'สำเร็จแล้ว',
        'statusColor': Colors.green,
      },
    ];

    return Scaffold(
      // 1. ปรับสีพื้นหลังให้เป็นพาสเทลสบายตา
      backgroundColor: Colors.deepPurple.shade50,
      
      // 2. แต่ง AppBar ให้โปร่งใสและดูทันสมัย
      appBar: AppBar(
        title: Text(
          'ติดตามสถานะ Escrow',
          style: TextStyle(
            color: Colors.deepPurple.shade800,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.deepPurple.shade800), // สีปุ่มย้อนกลับ
      ),
      
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        itemCount: mockOrders.length,
        itemBuilder: (context, index) {
          final order = mockOrders[index];
          
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            // 3. ใช้ Container แทน Card เพื่อแต่งเงาให้ฟุ้งและซอฟต์ขึ้น
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withOpacity(0.06),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0), // เพิ่มพื้นที่ว่างให้ดูไม่อึดอัด
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // แถวบน: รหัสออเดอร์ และ ป้ายสถานะ
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'รหัส: ${order['id']}',
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: (order['statusColor'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          order['status'],
                          style: TextStyle(
                            color: order['statusColor'],
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // เส้นคั่นบางๆ ไม่ให้กวนสายตา
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Divider(color: Colors.grey.shade100, height: 1, thickness: 1.5),
                  ),
                  
                  // แถวกลาง: รายละเอียดสินค้า
                  Row(
                    children: [
                      Container(
                        height: 64,
                        width: 64,
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.shade50,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(Icons.inventory_2_rounded, color: Colors.deepPurple.shade300, size: 32),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order['itemName'],
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey.shade800),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${order['price']} THB',
                              style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.w800, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // 4. แถวล่าง: ปุ่มกด (เปลี่ยนจาก Outline เป็นปุ่มทึบสีอ่อน)
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple.shade50, // สีพื้นปุ่มม่วงอ่อน
                        foregroundColor: Colors.deepPurple.shade700, // สีตัวหนังสือม่วงเข้ม
                        elevation: 0, // ปิดเงาให้ดูแบนราบ (Flat Design)
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('ดูรายละเอียดคำสั่งซื้อ ${order['id']}')),
                        );
                      },
                      child: const Text(
                        'ดูรายละเอียด / จัดการคำสั่งซื้อ',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}