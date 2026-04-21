// lib/features/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/app_locale_provider.dart';
import '../core/app_theme.dart';
import 'checkout_screen.dart';
import 'product_detail.dart';
import '../core/utils.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


// Design token aliases — source of truth is lib/core/app_theme.dart
const _kPurple = kPurple;
const _kPurpleLight = kPurpleLight;
const _kPurpleFaint = kPurpleFaint;
const _kPurpleBorder = kPurpleBorder;
const _kText = kText;

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final s = context.watch<AppLocaleProvider>().strings;

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
          s.cart,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: _kText,
          ),
        ),
        actions: [
          if (cart.items.isNotEmpty)
            TextButton(
              onPressed: cart.clear,
              child: Text(
                s.clearAll,
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: cart.items.isEmpty
          ? _EmptyCart(s: s)
          : Column(
              children: [
                // ── Select-all bar ──────────────────────────────────────
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: cart.allSelected
                            ? cart.deselectAll
                            : cart.selectAll,
                        child: Row(
                          children: [
                            _Checkbox(checked: cart.allSelected),
                            const SizedBox(width: 10),
                            Text(
                              s.selectAll,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: _kText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${cart.items.length} ${s.isThai ? 'รายการ' : 'item${cart.items.length > 1 ? 's' : ''}'}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFF0EAF8)),

                // ── Item list ───────────────────────────────────────────
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    itemCount: cart.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (ctx, i) => _CartItemTile(
                      cartItem: cart.items[i],
                      isSelected: cart.isSelected(cart.items[i].item.id),
                      onToggleSelect: () =>
                          cart.toggleSelected(cart.items[i].item.id),
                      onRemove: () => cart.removeItem(cart.items[i].item.id),
                    ),
                  ),
                ),

                // ── Order Summary + Checkout ─────────────────────────────
                _OrderSummaryPanel(cart: cart, s: s),
              ],
            ),
    );
  }
}

// ── Checkbox widget ──────────────────────────────────────────────────────────

class _Checkbox extends StatelessWidget {
  final bool checked;
  const _Checkbox({required this.checked});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: checked ? _kPurple : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: checked ? _kPurple : Colors.grey.shade300,
          width: 2,
        ),
      ),
      child: checked
          ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
          : null,
    );
  }
}

// ── Cart Item Tile ───────────────────────────────────────────────────────────

class _CartItemTile extends StatelessWidget {
  final CartItem cartItem;
  final bool isSelected;
  final VoidCallback onToggleSelect;
  final VoidCallback onRemove;

  const _CartItemTile({
    required this.cartItem,
    required this.isSelected,
    required this.onToggleSelect,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppLocaleProvider>().strings;
    final item = cartItem.item;
    return Slidable(
      key: ValueKey(item.id),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.22,
        children: [
          SlidableAction(
            onPressed: (_) => onRemove(),
            backgroundColor: _kPurple,
            foregroundColor: Colors.white,
            label: s.deleteLabel,
            borderRadius: const BorderRadius.horizontal(right: Radius.circular(16)),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? _kPurple.withOpacity(0.4) : _kPurpleBorder,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: _kPurpleLight.withOpacity(0.07),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Checkbox
            GestureDetector(
              onTap: onToggleSelect,
              child: _Checkbox(checked: isSelected),
            ),
            const SizedBox(width: 12),

            // Navigation to detail
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailScreen(item: item),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      // Product image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          width: 72,
                          height: 72,
                          child: Image.network(
                            item.imageUrl,
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

                      // Name + collection + price
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: _kText,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.collection.isNotEmpty
                                  ? item.collection
                                  : 'Meri-Mari',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              PriceFormatter.formatWithCurrency(item.price),
                              style: const TextStyle(

                                color: _kPurple,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Order Summary Panel ──────────────────────────────────────────────────────

class _OrderSummaryPanel extends StatelessWidget {
  final CartProvider cart;
  final dynamic s;
  const _OrderSummaryPanel({required this.cart, required this.s});

  @override
  Widget build(BuildContext context) {
    final selectedSubtotal = cart.selectedSubtotal;
    final shippingCost = cart.selectedShipping;
    final totalPayment = selectedSubtotal + shippingCost;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: _kPurpleLight.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              s.orderSummary,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: _kText,
              ),
            ),
            const SizedBox(height: 12),
            _SummaryRow(
              label: s.subtotal,
              value: PriceFormatter.formatWithCurrency(selectedSubtotal),
            ),

            const SizedBox(height: 6),
            _SummaryRow(
              label: s.shippingCost,
              value: shippingCost == 0
                  ? (s.isThai ? 'ฟรี' : 'Free')
                  : PriceFormatter.formatWithCurrency(shippingCost),

            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(height: 1, color: Color(0xFFF0EAF8)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  s.totalPayment,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: _kText,
                  ),
                ),
                Text(
                  PriceFormatter.formatWithCurrency(totalPayment),
                  style: const TextStyle(

                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: _kPurple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: cart.anySelected
                    ? () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CheckoutScreen(),
                        ),
                      )
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kPurple,
                  disabledBackgroundColor: Colors.grey.shade200,
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
                child: Text(s.checkout),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
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
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: _kText,
          ),
        ),
      ],
    );
  }
}

// ── Empty Cart ───────────────────────────────────────────────────────────────

class _EmptyCart extends StatelessWidget {
  final dynamic s;
  const _EmptyCart({required this.s});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: _kPurpleFaint,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              size: 48,
              color: _kPurpleLight,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            s.emptyCart,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _kText,
            ),
          ),
        ],
      ),
    );
  }
}
