//หน้าแรกและการค้นหา
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/item_provider.dart';
import '../../core/app_theme.dart';
import 'product_detail.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Meri Mari')),
      body: Column(
        children: [
          // ส่วน Search
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'ค้นหา Art Toy...', 
                prefixIcon: Icon(Icons.search)
              ),
              onChanged: (val) => itemProvider.setSearchQuery(val),
            ),
          ),
          // ส่วน Filter (Condition Tags)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ['All', 'Check Card', 'MISB'].map((cond) {
              return ActionChip(
                label: Text(cond),
                onPressed: () => itemProvider.setCondition(cond),
                backgroundColor: MeriMariTheme.lightPurple,
              );
            }).toList(),
          ),
          // รายการสินค้า
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8, // ปรับสัดส่วนการ์ดไม่ให้เนื้อหาเบียดกันเกินไป
              ),
              itemCount: itemProvider.filteredItems.length,
              itemBuilder: (context, index) {
                final item = itemProvider.filteredItems[index];
                return GestureDetector(
                onTap: () {
                  // เมื่อกดที่การ์ด ให้เปิดหน้า ProductDetailScreen และส่งข้อมูล item ไปด้วย
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailScreen(item: item),
                    ),
                  );
                },
                child:Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(item.imageUrl, height: 100),
                      const SizedBox(height: 8),
                      // แก้เป็น item.name ให้ตรงกับ ItemModel
                      Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)), 
                      // แก้เป็น item.price ให้ตรงกับ ItemModel
                      Text('${item.price} THB', style: const TextStyle(color: Colors.orange)), 
                    ],
                  ),
                ));
              },
            ),
          ),
        ],
      ),
    );
  }
}