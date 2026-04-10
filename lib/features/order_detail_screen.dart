// lib/features/order_detail_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/app_locale_provider.dart';
import '../providers/orders_provider.dart';
import '../providers/address_provider.dart';
import 'qr_payment_screen.dart';
import '../core/app_theme.dart';

class OrderDetailScreen extends StatefulWidget {
  final AppOrder order;
  const OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  Timer? _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _remaining = widget.order.timeRemaining;
    if (widget.order.tab == OrderTab.toPay && !widget.order.hasSlip) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        final r = widget.order.timeRemaining;
        if (!mounted) return;
        setState(() => _remaining = r);
        if (r == Duration.zero) {
          _timer?.cancel();
          context.read<OrdersProvider>().cancelOrder(widget.order.id);
          Navigator.pop(context);
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _fmt(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  static const _kPurple = Color(0xFF7B5EA7);
  static const _kPurpleLight = Color(0xFFAB9DC4);
  static const _kText = Color(0xFF2D264B);

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppLocaleProvider>().strings;
    final addrProvider = context.watch<AddressProvider>();
    final order = widget.order;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      appBar: AppBar(
        title: Text(
          s.orderDetail,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          children: [
            // ── 1. Status Banner ──────────────────────────────────────
            if (order.tab == OrderTab.toPay)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_kPurple, _kPurpleLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.hasSlip
                          ? s.waitingVerification
                          : '${s.payWithin} ${_fmt(_remaining)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.account_balance_wallet_outlined,
                          color: Colors.white70,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            order.hasSlip
                                ? s.sellerVerificationMsg
                                : s.payViaPromptPay,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            // ── 2. Shipping Address ──────────────────────────────────
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: _kPurple,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        s.shippingAddress,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: _kText,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (addrProvider.defaultAddress != null) ...[
                    Text(
                      addrProvider.defaultAddress!.summary,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                  ] else
                    Text(
                      s.noAddress,
                      style: const TextStyle(color: Colors.grey),
                    ),
                ],
              ),
            ),

            // ── 3. Product Details ──────────────────────────────────
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _kPurple,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          s.mallLabel,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        s.shopOfficialStore,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
                  const Divider(height: 24),
                  ...order.items.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: item.imageUrl.isNotEmpty
                                ? Image.network(
                                    item.imageUrl,
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    width: 70,
                                    height: 70,
                                    color: Colors.grey.shade200,
                                  ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '฿${item.price.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        color: _kPurple,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Text(
                                      'x${item.quantity}',
                                      style: const TextStyle(
                                        color: Colors.grey,
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
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        s.orderTotalLabel,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Text(
                        '฿${order.total.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          color: _kPurple,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── 4. Service ──────────────────────────────────────────
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _ServiceTile(
                    icon: Icons.chat_bubble_outline,
                    title: s.contactSeller,
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _ServiceTile(icon: Icons.help_outline, title: s.helpCenter),
                ],
              ),
            ),

            // ── 5. Order Info ──────────────────────────────────────
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _InfoRow(
                    label: s.orderId,
                    value: order.id,
                    onCopy: () {
                      Clipboard.setData(ClipboardData(text: order.id));
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(s.copiedLabel)));
                    },
                  ),
                  const SizedBox(height: 12),
                  _InfoRow(
                    label: s.orderTimeLabel,
                    value:
                        '${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year} ${order.createdAt.hour}:${order.createdAt.minute}',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: (order.tab == OrderTab.toPay && !order.hasSlip)
          ? Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(
                          color: kErrorRedDark.withValues(alpha: 0.4),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        s.cancelOrderLabel,
                        style: const TextStyle(
                          color: kErrorRedDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QrPaymentScreen(
                              total: order.total,
                              selectedItems: const [],
                              orderId: order.id,
                            ),
                          ),
                        ).then(
                          (_) => Navigator.pop(context),
                        ); // Pop back after payment
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _kPurple,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        s.payNowLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final IconData icon;
  final String title;
  const _ServiceTile({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey.shade600, size: 20),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, color: Color(0xFF2D264B)),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
      onTap: () {},
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onCopy;
  const _InfoRow({required this.label, required this.value, this.onCopy});

  @override
  Widget build(BuildContext context) {
    final s = context.read<AppLocaleProvider>().strings;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        Row(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D264B),
              ),
            ),
            if (onCopy != null) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onCopy,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    s.copy,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
