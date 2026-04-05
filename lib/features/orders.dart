// lib/features/orders.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_locale_provider.dart';
import '../providers/orders_provider.dart';
import '../l10n/app_strings.dart';
import 'qr_payment_screen.dart';
import 'order_detail_screen.dart';
import '../core/app_theme.dart';

const _kPurple      = kPurple;
const _kPurpleLight = kPurpleLight;
const _kPurpleFaint = kPurpleFaint;
const _kText = Color(0xFF1A1A2E);

class OrdersScreen extends StatefulWidget {
  final int initialTab;
  const OrdersScreen({super.key, this.initialTab = 0});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 5,
      vsync: this,
      initialIndex: widget.initialTab,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppLocaleProvider>().strings;
    final ordersProvider = context.watch<OrdersProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F0FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 20,
                  color: _kText,
                ),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          s.orders,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: _kText,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelColor: _kPurple,
          labelPadding: const EdgeInsets.symmetric(horizontal: 20),
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 14,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          indicatorColor: _kPurple,
          indicatorWeight: 3,
          tabs: [
            Tab(text: s.tabAll),
            Tab(text: s.tabToPay),
            Tab(text: s.tabToShip),
            Tab(text: s.tabToReceive),
            Tab(text: s.tabToRate),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _OrderList(
            orders: ordersProvider.orders,
            tab: null, // null means "All"
            s: s,
          ),
          _OrderList(
            orders: ordersProvider.ordersForTab(OrderTab.toPay),
            tab: OrderTab.toPay,
            s: s,
          ),
          _OrderList(
            orders: ordersProvider.ordersForTab(OrderTab.toShip),
            tab: OrderTab.toShip,
            s: s,
          ),
          _OrderList(
            orders: ordersProvider.ordersForTab(OrderTab.toReceive),
            tab: OrderTab.toReceive,
            s: s,
          ),
          _OrderList(
            orders: ordersProvider.ordersForTab(OrderTab.toRate),
            tab: OrderTab.toRate,
            s: s,
          ),
        ],
      ),
    );
  }
}

// ── Order List ───────────────────────────────────────────────────────────────

class _OrderList extends StatelessWidget {
  final List<AppOrder> orders;
  final OrderTab? tab;
  final AppStrings s;
  const _OrderList({required this.orders, this.tab, required this.s});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(
                color: _kPurpleFaint,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
                size: 42,
                color: _kPurpleLight,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              s.noOrders,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: _kText,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
      itemCount: orders.length,
      itemBuilder: (ctx, i) {
        // Use Shopee-style card if the order itself is in 'To Pay' state,
        // even if we are currently viewing the 'All' tab.
        if (orders[i].tab == OrderTab.toPay) {
          return _ToPayCard(order: orders[i], s: s);
        }
        return _GenericOrderCard(order: orders[i], s: s);
      },
    );
  }
}

// ── To Pay Card (Shopee-style with 24h countdown) ────────────────────────────

class _ToPayCard extends StatefulWidget {
  final AppOrder order;
  final AppStrings s;
  const _ToPayCard({required this.order, required this.s});

  @override
  State<_ToPayCard> createState() => _ToPayCardState();
}

class _ToPayCardState extends State<_ToPayCard> {
  Timer? _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _remaining = widget.order.timeRemaining;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final r = widget.order.timeRemaining;
      if (!mounted) return;
      setState(() => _remaining = r);
      if (r == Duration.zero) {
        _timer?.cancel();
        // Auto-cancel expired order
        context.read<OrdersProvider>().cancelOrder(widget.order.id);
      }
    });
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

  void _confirmCancel(BuildContext ctx, String orderId, AppStrings s) {
    showDialog(
      context: ctx,
      builder: (dlg) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          s.isThai ? 'ยกเลิกออเดอร์?' : 'Cancel Order?',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: _kText,
          ),
        ),
        content: Text(
          s.isThai
              ? 'หากยกเลิก สินค้าจะกลับมาให้ผู้อื่นสามารถสั่งซื้อได้อีกครั้ง'
              : 'The item will be available for others to purchase again.',
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black54,
            height: 1.4,
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(12, 0, 24, 24),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dlg),
            child: Text(
              s.cancelLabel,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kPurple,
              foregroundColor: Colors.white,
              elevation: 4,
              shadowColor: kPurple.withValues(alpha: 0.3),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {
              Navigator.pop(dlg);
              context.read<OrdersProvider>().cancelOrder(orderId);
            },
            child: Text(
              s.confirmCancelLabel,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final s = widget.s;
    final expired = _remaining == Duration.zero;

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OrderDetailScreen(order: order),
        ),
      ),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7B5EA7).withValues(alpha: 0.07),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // ── Shop header ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: _kPurple,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        s.recommendedShop,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      s.shopOfficialStore,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: _kText,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: _kPurpleFaint,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    s.tabToPay,
                    style: const TextStyle(
                      color: _kPurple,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFF0EAF8)),

          // ── Items list ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Column(
              children: order.items
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: item.imageUrl.isNotEmpty
                                ? Image.network(
                                    item.imageUrl,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        _imgPlaceholder(),
                                  )
                                : _imgPlaceholder(),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: _kText,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '฿${item.price.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: _kPurple,
                                      ),
                                    ),
                                    Text(
                                      'x${item.quantity}',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade500,
                                        fontWeight: FontWeight.w600,
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
                  )
                  .toList(),
            ),
          ),

          // ── Subtotal ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  s.isThai
                      ? 'สินค้ารวม ${order.items.length} รายการ: '
                      : '${order.items.length} item(s): ',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                Text(
                  '฿${order.total.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: _kText,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFF0EAF8)),

          // ── Slip verification banner (shown when slip uploaded) ───────
          if (order.hasSlip)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _kPurpleFaint,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _kPurpleLight.withValues(alpha: 0.2)),
                ),
                alignment: Alignment.center,
                child: Text(
                  s.waitingVerification, // "รอตรวจสอบสลิปชำระเงิน"
                  style: const TextStyle(
                    color: _kPurple,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
            ),

          // ── Countdown timer + action buttons (hidden when slip uploaded)
          if (!order.hasSlip) ...[
            // Countdown timer row
            InkWell(
              onTap: expired
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QrPaymentScreen(
                            total: order.total,
                            selectedItems: const [],
                            orderId: order.id,
                          ),
                        ),
                      );
                    },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _kPurpleFaint,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: expired
                            ? Text(
                                s.isThai
                                    ? 'หมดเวลาชำระเงิน — ออเดอร์ถูกยกเลิก'
                                    : 'Payment expired — order cancelled',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.red.shade400,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            : RichText(
                                text: TextSpan(
                                  style: const TextStyle(fontSize: 13),
                                  children: [
                                    TextSpan(
                                      text: s.payWithin + ' ',
                                      style: const TextStyle(color: Colors.black54),
                                    ),
                                    TextSpan(
                                      text: _fmt(_remaining),
                                      style: const TextStyle(
                                        color: _kPurple,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 15,
                                      ),
                                    ),
                                    TextSpan(
                                      text: s.isThai
                                          ? ' ผ่าน QR พร้อมเพย์'
                                          : ' via QR PromptPay',
                                      style: const TextStyle(color: Colors.black54),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                      if (!expired)
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: _kPurpleLight,
                        ),
                    ],
                  ),
                ),
              ),
            ),

            const Divider(height: 1, color: Color(0xFFF0EAF8)),

            // Action buttons
            if (!expired)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Row(
                  children: [
                    const Spacer(),
                    SizedBox(
                      width: 140,
                      child: OutlinedButton(
                        onPressed: () => _confirmCancel(context, order.id, s),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          s.cancelOrderLabel,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 120,
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
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _kPurple,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          s.payNowLabel,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    ),
  );
}

  Widget _imgPlaceholder() {
    return Container(
      width: 60,
      height: 60,
      decoration: const BoxDecoration(
        color: _kPurpleFaint,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: const Icon(
        Icons.inventory_2_rounded,
        color: _kPurpleLight,
        size: 26,
      ),
    );
  }
}

// ── Generic Order Card (To Ship / To Receive / To Rate) ──────────────────────

class _GenericOrderCard extends StatelessWidget {
  final AppOrder order;
  final AppStrings s;
  const _GenericOrderCard({required this.order, required this.s});

  String _statusLabel(OrderTab tab, AppStrings s) {
    switch (tab) {
      case OrderTab.toPay:
        return s.isThai ? 'รอผู้ซื้อชำระเงิน' : 'Pending Payment';
      case OrderTab.toShip:
        return s.isThai ? 'ผู้ขายกำลังจัดส่ง' : 'Shipping';
      case OrderTab.toReceive:
        return s.isThai ? 'รอรับสินค้า' : 'To Receive';
      case OrderTab.toRate:
        return s.isThai ? 'สำเร็จ' : 'Success';
    }
  }

  Color _statusColor(OrderTab tab) {
    switch (tab) {
      case OrderTab.toPay:
        return _kPurple;
      case OrderTab.toShip:
        return const Color(0xFF2196F3);
      case OrderTab.toReceive:
        return const Color(0xFF9C27B0);
      case OrderTab.toRate:
        return const Color(0xFF4CAF50);
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(order.tab);
    final firstItem = order.items.isNotEmpty ? order.items.first : null;

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OrderDetailScreen(order: order),
        ),
      ),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7B5EA7).withValues(alpha: 0.07),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'รหัส: ${order.id}',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _statusLabel(order.tab, s),
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Divider(
                  color: Colors.grey.shade100,
                  height: 1,
                  thickness: 1.5,
                ),
              ),
              if (firstItem != null)
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: firstItem.imageUrl.isNotEmpty
                          ? Image.network(
                              firstItem.imageUrl,
                              width: 62,
                              height: 62,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _placeholder(),
                            )
                          : _placeholder(),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            firstItem.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: Colors.grey.shade800,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '฿${order.total.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: _kPurple,
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _kPurpleFaint,
                    foregroundColor: _kPurple,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrderDetailScreen(order: order),
                    ),
                  ),
                  child: Text(
                    s.isThai
                        ? 'ดูรายละเอียด / จัดการคำสั่งซื้อ'
                        : 'View / Manage Order',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 62,
      height: 62,
      decoration: const BoxDecoration(
        color: _kPurpleFaint,
        borderRadius: BorderRadius.all(Radius.circular(14)),
      ),
      child: const Icon(
        Icons.inventory_2_rounded,
        color: _kPurpleLight,
        size: 30,
      ),
    );
  }
}
