// lib/features/orders.dart
import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data สำหรับแสดงผลหน้าจอไปก่อน
    // ของจริงคุณสามารถดึงข้อมูลจาก EscrowProvider หรือ OrderProvider ได้ครับ
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
      appBar: AppBar(
        title: const Text('ติดตามสถานะ Escrow'),
        centerTitle: true,
        backgroundColor: Colors.purple.shade50,
      ),
      backgroundColor: Colors.grey.shade100, // พื้นหลังสีเทาอ่อนให้การ์ดดูเด่นขึ้น
      body: ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: mockOrders.length,
        itemBuilder: (context, index) {
          final order = mockOrders[index];
          
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // แถวบน: รหัสออเดอร์ และ ป้ายสถานะ
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'รหัส: ${order['id']}',
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: (order['statusColor'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: order['statusColor']),
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
                  const Divider(height: 24),
                  
                  // แถวกลาง: รายละเอียดสินค้า
                  Row(
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.purple.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.inventory_2_outlined, color: Colors.purple),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order['itemName'],
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${order['price']} THB',
                              style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // แถวล่าง: ปุ่มกดดูรายละเอียด
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.purple,
                        side: const BorderSide(color: Colors.purple),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        // อนาคตสามารถกดเพื่อเข้าไปดูรายละเอียดการจัดส่ง หรือกดยืนยันรับของ (Release Funds)
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('ดูรายละเอียดคำสั่งซื้อ ${order['id']}')),
                        );
                      },
                      child: const Text('ดูรายละเอียด / จัดการคำสั่งซื้อ'),
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