// lib/features/home.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/item_provider.dart';
import 'product_detail.dart';
import 'orders.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FF),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            automaticallyImplyLeading: false,
            floating: true,
            snap: true,
            backgroundColor: Colors.white,
            elevation: 0,
            titleSpacing: 20,
            title: Row(
              children: [
                // Logo / title
                Text(
                  'Meri Mari',
                  style: TextStyle(
                    color: Colors.deepPurple.shade800,
                    fontWeight: FontWeight.w900,
                    fontSize: 26,
                    letterSpacing: 0.4,
                  ),
                ),
                const Spacer(),
                // Orders icon button
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDE7F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.receipt_long_rounded,
                      color: Colors.deepPurple.shade700,
                      size: 24,
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const OrdersScreen()),
                    ),
                  ),
                ),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(72),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: _SearchBar(itemProvider: itemProvider),
              ),
            ),
          ),
        ],
        body: itemProvider.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF6A1B9A)),
              )
            : itemProvider.error != null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.cloud_off_rounded,
                        size: 64,
                        color: Colors.deepPurple.shade200,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        itemProvider.error!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.deepPurple.shade400,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filter chips
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Filter:',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.deepPurple.shade400,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: ['All', 'Check Card', 'MISB'].map((
                                cond,
                              ) {
                                final selected =
                                    itemProvider.selectedCondition == cond;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    child: FilterChip(
                                      label: Text(cond),
                                      selected: selected,
                                      onSelected: (_) =>
                                          itemProvider.setCondition(cond),
                                      selectedColor: const Color(0xFF6A1B9A),
                                      backgroundColor: Colors.white,
                                      checkmarkColor: Colors.white,
                                      labelStyle: TextStyle(
                                        color: selected
                                            ? Colors.white
                                            : Colors.deepPurple.shade700,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: BorderSide(
                                          color: selected
                                              ? const Color(0xFF6A1B9A)
                                              : Colors.deepPurple.shade100,
                                          width: 1.5,
                                        ),
                                      ),
                                      elevation: 0,
                                      pressElevation: 0,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 2,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Grid
                  Expanded(
                    child: itemProvider.filteredItems.isEmpty
                        ? _EmptyState()
                        : GridView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.72,
                                  crossAxisSpacing: 14,
                                  mainAxisSpacing: 14,
                                ),
                            itemCount: itemProvider.filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = itemProvider.filteredItems[index];
                              return _ProductCard(
                                item: item,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ProductDetailScreen(item: item),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
      ),
    );
  }
}

// ── Search bar ─────────────────────────────────────────────────────────────────
class _SearchBar extends StatelessWidget {
  final ItemProvider itemProvider;
  const _SearchBar({required this.itemProvider});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFF3EEF8),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: 'ค้นหา Art Toy...',
          hintStyle: TextStyle(color: Colors.deepPurple.shade300, fontSize: 14),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.deepPurple.shade400,
            size: 22,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onChanged: (val) => itemProvider.setSearchQuery(val),
      ),
    );
  }
}

// ── Product card ───────────────────────────────────────────────────────────────
class _ProductCard extends StatelessWidget {
  final dynamic item;
  final VoidCallback onTap;
  const _ProductCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.07),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      item.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFFF3EEF8),
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.deepPurple.shade100,
                        ),
                      ),
                    ),
                    // Gradient overlay
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.0),
                              Colors.black.withOpacity(0.12),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Info
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: Color(0xFF212121),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '฿${item.price}',
                        style: const TextStyle(
                          color: Color(0xFFE65100),
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDE7F6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.favorite_border_rounded,
                          size: 14,
                          color: Color(0xFF6A1B9A),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty state ────────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 72,
            color: Colors.deepPurple.shade200,
          ),
          const SizedBox(height: 16),
          Text(
            'ไม่พบสินค้า',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.deepPurple.shade400,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'ลองค้นหาด้วยคำอื่นดูนะครับ',
            style: TextStyle(fontSize: 14, color: Colors.deepPurple.shade300),
          ),
        ],
      ),
    );
  }
}
