// lib/features/home.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/item_provider.dart';
import '../core/app_theme.dart';
import 'product_detail.dart';
import 'orders.dart'; // Import หน้า Orders เข้ามาสำหรับปุ่มด้านบน

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);

    return Scaffold(
      // 1. เปลี่ยนสีพื้นหลังให้เป็นพาสเทลสบายตา เข้ากับหน้า Login
      backgroundColor: Colors.deepPurple.shade50,
      
      // 2. ปรับแต่ง AppBar ให้ดูคลีนและทันสมัย
      appBar: AppBar(
        backgroundColor: Colors.transparent, // โปร่งใสกลืนไปกับพื้นหลัง
        elevation: 0,
        title: Text(
          'Meri Mari',
          style: TextStyle(
            color: Colors.deepPurple.shade800,
            fontWeight: FontWeight.w800,
            fontSize: 24,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: false,
        actions: [
          // ปุ่มไปหน้าติดตามสถานะ Escrow (Orders)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: Icon(Icons.receipt_long_rounded, color: Colors.deepPurple.shade700, size: 28),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OrdersScreen()),
                );
              },
            ),
          ),
        ],
      ),
      
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 3. ส่วน Search (ดีไซน์ใหม่ ลบเส้นขอบแข็งๆ เพิ่มความโค้งมนและเงา)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'ค้นหา Art Toy...',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  prefixIcon: Icon(Icons.search, color: Colors.deepPurple.shade300),
                  border: InputBorder.none, // ลบเส้นขอบทิ้ง
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onChanged: (val) => itemProvider.setSearchQuery(val),
              ),
            ),
          ),
          
          // 4. ส่วน Filter (Condition Tags) ทำให้เลื่อนซ้ายขวาได้
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Check Card', 'MISB'].map((cond) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: ActionChip(
                      label: Text(
                        cond,
                        style: TextStyle(
                          color: Colors.deepPurple.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      backgroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.deepPurple.shade100, width: 1.5), // ขอบสีม่วงอ่อน
                      ),
                      onPressed: () => itemProvider.setCondition(cond),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          
          const SizedBox(height: 8),

          // 5. รายการสินค้า (ดีไซน์การ์ดใหม่)
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72, // ปรับความสูงการ์ดให้พอดีกับรูปและข้อความ
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: itemProvider.filteredItems.length,
              itemBuilder: (context, index) {
                final item = itemProvider.filteredItems[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(item: item),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // รูปภาพ (ตัดมุมโค้งเฉพาะด้านบน)
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                            child: Image.network(
                              item.imageUrl,
                              width: double.infinity,
                              fit: BoxFit.cover, // ให้รูปเต็มกรอบ
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    color: Colors.grey.shade100,
                                    child: const Icon(Icons.image_not_supported, color: Colors.grey),
                                  ),
                            ),
                          ),
                        ),
                        // รายละเอียดข้อความ จัดชิดซ้าย
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.grey.shade800,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis, // ถ้ายาวไปให้เป็น ...
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${item.price} THB',
                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}