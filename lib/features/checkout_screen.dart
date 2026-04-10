// lib/features/checkout_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/app_locale_provider.dart';
import '../providers/address_provider.dart';
import '../core/app_theme.dart';
import 'qr_payment_screen.dart';
import 'address_screen.dart';

// Design token aliases — source of truth is lib/core/app_theme.dart
const _kPurple       = kPurple;
const _kPurpleLight  = kPurpleLight;
const _kPurpleFaint  = kPurpleFaint;
const _kPurpleBorder = kPurpleBorder;
const _kText         = kText;

class CheckoutScreen extends StatelessWidget {
  final List<CartItem>? directItems;

  const CheckoutScreen({super.key, this.directItems});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final s = context.watch<AppLocaleProvider>().strings;
    final addressProvider = context.watch<AddressProvider>();

    final isDirectBuy = directItems != null;
    final selectedItems = isDirectBuy
        ? directItems!
        : cart.items.where((ci) => cart.isSelected(ci.item.id)).toList();

    final subtotal = isDirectBuy
        ? selectedItems.fold(
            0.0,
            (sum, ci) => sum + (ci.item.price * ci.quantity),
          )
        : cart.selectedSubtotal;

    // Placeholder fixed shipping: 50. In the reference image, it shows ฿50 for shipping.
    final shipping = isDirectBuy ? 50.0 : cart.selectedShipping;
    final total = subtotal + shipping;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: _kText,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          s.checkoutTitle,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: _kText,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Delivery Address ────────────────────────────────────────
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddressScreen()),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: _SectionCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      color: _kPurple,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.deliveryAddress,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: _kText,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            addressProvider.locationSummary.isNotEmpty
                                ? addressProvider.locationSummary
                                : s.noAddress,
                            style: TextStyle(
                              fontSize: 13,
                              color: addressProvider.locationSummary.isNotEmpty
                                  ? const Color(0xFF444444)
                                  : Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── Order Items ─────────────────────────────────────────────
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.shopping_bag_outlined,
                        color: _kPurple,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Meri-Mari',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: _kText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...selectedItems.map(
                    (ci) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              width: 64,
                              height: 64,
                              child: Image.network(
                                ci.item.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: _kPurpleFaint,
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    color: _kPurpleBorder,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ci.item.name,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: _kText,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (ci.item.collection.isNotEmpty)
                                  Text(
                                    ci.item.collection,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                const SizedBox(height: 4),
                                Text(
                                  '฿${ci.item.price.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: _kPurple,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xFFF0EAF8)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        s.isThai
                            ? 'สินค้ารวม ${selectedItems.length} ชิ้น'
                            : '${selectedItems.length} item(s)',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        '฿${subtotal.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: _kText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ── Payment Method ─────────────────────────────────────────
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.paymentMethod,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: _kText,
                    ),
                  ),
                  const SizedBox(height: 14),
                  // QR PromptPay row (only option)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: _kPurpleFaint,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _kPurple, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: _kPurpleBorder),
                          ),
                          child: const Icon(
                            Icons.qr_code_2_rounded,
                            color: _kPurple,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            s.qrPromptPay,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: _kText,
                            ),
                          ),
                        ),
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: _kPurple,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ── Order Summary ──────────────────────────────────────────
            _SectionCard(
              child: Column(
                children: [
                  _SummaryRow(
                    label: s.isThai ? 'รวมการสั่งซื้อ' : 'Subtotal',
                    value: '฿${subtotal.toStringAsFixed(0)}',
                  ),
                  const SizedBox(height: 8),
                  _SummaryRow(
                    label: s.shippingCost,
                    value: shipping == 0
                        ? (s.isThai ? 'ฟรี' : 'Free')
                        : '฿${shipping.toStringAsFixed(0)}',
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(height: 1, color: Color(0xFFF0EAF8)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        s.isThai ? 'ยอดชำระเงินทั้งหมด' : 'Total Payment',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: _kText,
                        ),
                      ),
                      Text(
                        '฿${total.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: _kPurple,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),

      // ── Bottom Order Bar ─────────────────────────────────────────────
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(
          20,
          12,
          20,
          MediaQuery.of(context).padding.bottom + 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: _kPurpleLight.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.isThai ? 'รวมยอดสั่งซื้อ' : 'Total',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
                Text(
                  '฿${total.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: _kPurple,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    // Check if delivery address is missing
                    if (addressProvider.defaultAddress == null) {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: Colors.white,
                          surfaceTintColor: Colors.transparent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          content: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.location_off_rounded, color: _kPurpleLight, size: 52),
                                const SizedBox(height: 16),
                                Text(
                                  s.isThai ? 'ไม่มีที่อยู่จัดส่ง' : 'No Delivery Address',
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w900,
                                    color: _kText,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  s.isThai
                                      ? 'กรุณาเพิ่มที่อยู่จัดส่งในหน้าโปรไฟล์ หรือกดเลือกที่อยู่ก่อนทำการสั่งซื้อ'
                                      : 'Please add a delivery address or select one before placing your order.',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: _kText,
                                    height: 1.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                          actionsPadding: EdgeInsets.zero,
                          actions: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border(top: BorderSide(color: Colors.grey.shade200)),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                      },
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(16),
                                            bottomRight: Radius.circular(16),
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        s.isThai ? 'ตกลง' : 'OK',
                                        style: const TextStyle(
                                          color: _kPurple,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QrPaymentScreen(
                          total: total,
                          selectedItems: selectedItems,
                        ),
                      ),
                    );
                    // Only clear cart if it was a cart checkout
                    if (!isDirectBuy) {
                      context.read<CartProvider>().clear();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _kPurple,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: Text(s.placeOrder),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Helpers ──────────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFAB9DC4).withValues(alpha: 0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Color(0xFF666666)),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: _kText,
          ),
        ),
      ],
    );
  }
}
