// lib/features/product_detail.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/item_model.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/app_locale_provider.dart';
import 'checkout_screen.dart'; // Changed from orders.dart
import '../providers/orders_provider.dart';

// ─── Design tokens ────────────────────────────────────────────────────────────
const _kPurple = Color(0xFF7B5EA7);
const _kPurpleFaint = Color(0xFFF4F0FA);
const _kPurpleBorder = Color(0xFFDDD6E8);
const _kText = Color(0xFF1A1A2E);
const _kSubText = Color(0xFFB0A8C4);

class ProductDetailScreen extends StatefulWidget {
  final ItemModel item;
  const ProductDetailScreen({super.key, required this.item});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _heartCtrl;
  late Animation<double> _heartScale;
  final PageController _imageCtrl = PageController();
  int _imagePage = 0;

  @override
  void initState() {
    super.initState();
    _heartCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _heartScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _heartCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _heartCtrl.dispose();
    _imageCtrl.dispose();
    super.dispose();
  }

  void _toggleFavorite() {
    _heartCtrl.forward(from: 0);
    context.read<FavoritesProvider>().toggleFavorite(widget.item);
  }

  void _addToCart() {
    context.read<CartProvider>().addItem(widget.item);
    final s = context.read<AppLocaleProvider>().strings;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 10),
            Text(s.addedToCart),
          ],
        ),
        backgroundColor: _kPurple,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isFav = context.watch<FavoritesProvider>().isFavorite(widget.item.id);
    final s = context.watch<AppLocaleProvider>().strings;
    final isOrdered = context.watch<OrdersProvider>().isOrdered(widget.item.id);
    final images = widget.item.imageUrls;
    final hasMultipleImages = images.length > 1;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: CircleAvatar(
            backgroundColor: Colors.white.withValues(alpha: 0.9),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: _kText,
                size: 18,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundColor: Colors.white.withValues(alpha: 0.9),
              child: ScaleTransition(
                scale: _heartScale,
                child: IconButton(
                  icon: Icon(
                    isFav
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: isFav ? _kPurple : Colors.black87,
                    size: 20,
                  ),
                  onPressed: _toggleFavorite,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image Carousel ──────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 380,
              child: Stack(
                children: [
                  // PageView of images
                  PageView.builder(
                    controller: _imageCtrl,
                    itemCount: images.isEmpty ? 1 : images.length,
                    onPageChanged: (p) => setState(() => _imagePage = p),
                    itemBuilder: (ctx, i) {
                      if (images.isEmpty) {
                        return Container(
                          color: _kPurpleFaint,
                          child: const Icon(
                            Icons.image_not_supported_rounded,
                            size: 80,
                            color: _kPurpleBorder,
                          ),
                        );
                      }
                      return Image.network(
                        images[i],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (_, __, ___) => Container(
                          color: _kPurpleFaint,
                          child: const Icon(
                            Icons.image_not_supported_rounded,
                            size: 80,
                            color: _kPurpleBorder,
                          ),
                        ),
                      );
                    },
                  ),

                  // Dot indicators (only show when multiple images)
                  if (hasMultipleImages)
                    Positioned(
                      bottom: 32,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(images.length, (i) {
                          final isActive = i == _imagePage;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: isActive ? 20 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          );
                        }),
                      ),
                    ),

                  // Image counter badge (top right)
                  if (hasMultipleImages)
                    Positioned(
                      top: 56,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_imagePage + 1}/${images.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  // Out of stock overlay (when item is in an active order)
                  if (isOrdered)
                    Positioned.fill(
                      child: Container(
                        color: const Color(0xFF7B5EA7).withValues(alpha: 0.70),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.do_not_disturb_on_rounded,
                                color: Colors.white,
                                size: 48,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                s.isThai ? 'สินค้าหมด' : 'Out of Stock',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                s.isThai
                                    ? 'สินค้าชิ้นนี้ถูกจองแล้ว'
                                    : 'This item is already reserved',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ── Info Card ───────────────────────────────────────────────
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              transform: Matrix4.translationValues(0, -20, 0),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name + Price row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            widget.item.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: _kText,
                              height: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '฿${widget.item.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: _kPurple,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Tags section
                    if (widget.item.tags.isNotEmpty) ...[
                      Text(
                        s.tagsLabel,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _kSubText,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.item.tags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _kPurpleFaint,
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                color: _kPurpleBorder,
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              s.tagLabel(tag),
                              style: const TextStyle(
                                color: _kPurple,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Details box
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: _kPurpleFaint,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: _kPurpleBorder, width: 1),
                      ),
                      child: Column(
                        children: [
                          _DetailRow(
                            label: s.collection,
                            value: widget.item.collection,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Divider(color: _kPurpleBorder, height: 1),
                          ),
                          _DetailRow(
                            label: s.shipping,
                            value:
                                '฿${widget.item.shippingCost.toStringAsFixed(0)}',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Description
                    Text(
                      s.details,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: _kText,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      s.productDesc,
                      style: const TextStyle(
                        color: _kSubText,
                        height: 1.6,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom action bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: _kPurple.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: isOrdered ? null : _addToCart,
                  icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                  label: Text(
                    isOrdered
                        ? (s.isThai ? 'สินค้าหมด' : 'Out of Stock')
                        : s.addToCart,
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isOrdered ? Colors.grey : _kPurple,
                    side: BorderSide(
                      color: isOrdered ? Colors.grey.shade300 : _kPurple,
                      width: 1.5,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: isOrdered
                      ? null
                      : () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CheckoutScreen(
                              directItems: [
                                CartItem(item: widget.item, quantity: 1),
                              ],
                            ),
                          ),
                        ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isOrdered
                        ? Colors.grey.shade300
                        : _kPurple,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: Text(
                    isOrdered
                        ? (s.isThai ? 'ไม่สามารถสั่งซื้อได้' : 'Unavailable')
                        : s.buyNow,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _kSubText,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: _kText,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
