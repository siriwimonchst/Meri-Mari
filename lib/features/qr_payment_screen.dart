import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_locale_provider.dart';
import '../providers/cart_provider.dart';
import '../core/app_theme.dart';
import '../core/slip_upload_service.dart';
import 'orders.dart';
import '../providers/orders_provider.dart';
import '../providers/notifications_provider.dart';
import '../core/utils.dart';


// Design token aliases — source of truth is lib/core/app_theme.dart
const _kPurple       = kPurple;
const _kPurpleLight  = kPurpleLight;
const _kPurpleFaint  = kPurpleFaint;
const _kPurpleBorder = kPurpleBorder;
const _kText         = kText;

class QrPaymentScreen extends StatefulWidget {
  final double total;
  final List<dynamic> selectedItems;
  final String? orderId;

  const QrPaymentScreen({
    super.key,
    required this.total,
    required this.selectedItems,
    this.orderId,
  });

  @override
  State<QrPaymentScreen> createState() => _QrPaymentScreenState();
}

class _QrPaymentScreenState extends State<QrPaymentScreen> {
  String? _activeOrderId;
  Uint8List? _webImageBytes;
  bool _uploading = false;
  bool _uploaded  = false;
  double _uploadProgress = 0;
  String? _uploadError;

  @override
  void initState() {
    super.initState();
    _activeOrderId = widget.orderId;
  }

  // ── Slip upload using real Firebase Storage ─────────────────────────────
  Future<void> _pickSlip() async {
    // Only called for existing orders or after order is placed.
    if (_activeOrderId == null) return;

    // Demo mode: skip ImagePicker and use a mock transparent PNG.
    final bytes = Uint8List.fromList(const [
      137, 80, 78, 71, 13, 10, 26, 10, 0, 0, 0, 13, 73, 72, 68, 82, 
      0, 0, 0, 1, 0, 0, 0, 1, 8, 6, 0, 0, 0, 31, 21, 196, 137, 
      0, 0, 0, 11, 73, 68, 65, 84, 8, 215, 99, 96, 0, 2, 0, 0, 5, 
      0, 1, 243, 255, 34, 14, 0, 0, 0, 0, 73, 69, 78, 68, 174, 66, 96, 130
    ]);
    final s = context.read<AppLocaleProvider>().strings;
    final np = context.read<NotificationsProvider>();

    setState(() {
      _webImageBytes  = bytes; // Use bytes for preview on both web and mobile
      _uploading      = true;
      _uploadProgress = 0;
      _uploadError    = null;
    });

    // ── 2. Upload to Firestore (No Storage bucket used) ──────────────────
    try {
      await SlipUploadService.instance.uploadSlip(
        slipBytes: bytes,
        orderId:   _activeOrderId ?? 'unknown',
        onProgress: (p) {
          if (mounted) setState(() => _uploadProgress = p);
        },
      );

      if (!mounted) return;
      
      // Update local provider state and trigger notification
      await context.read<OrdersProvider>().markSlipUploaded(_activeOrderId!, np);

      setState(() {
        _uploading = false;
        _uploaded  = true;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(s.uploadSuccessAwaitAdmin),
          backgroundColor: _kPurpleLight,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        ),
      );

      // Navigate to orders screen so the user can see their order
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const OrdersScreen(initialTab: 0),
          ),
          (route) => route.isFirst,
        );
      });
    } catch (e) {

      if (!mounted) return;
      setState(() {
        _uploading   = false;
        _uploadError = e.toString().replaceFirst('Exception: ', '');
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${s.uploadFailedPrefix}$_uploadError'),
          backgroundColor: _kPurple,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  Future<void> _handleUploadPressed() async {
    final s = context.read<AppLocaleProvider>().strings;
    final proceed = await showDialog<bool>(
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
              const Icon(Icons.info_outline_rounded, color: _kPurple, size: 52),
              const SizedBox(height: 12),
              Text(
                s.demoNoticeMsg,
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
                    onPressed: () => Navigator.pop(ctx, true),
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
                      s.okLabel,
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

    if (proceed == true) {
      if (_activeOrderId == null) {
        // CASE: Initial Checkout -> Demo only as requested
        // Simply return to page 1 (QR screen) without changes
        return;
      } else {
        // CASE: Paying for existing order -> Real upload
        _pickSlip();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppLocaleProvider>().strings;

    return Scaffold(
      backgroundColor: Colors.white,
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
          s.scanQrToPay,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: _kText,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ── Amount Banner ───────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7B5EA7), Color(0xFFAB9DC4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    s.amountDue,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    PriceFormatter.formatWithCurrency(widget.total),
                    style: const TextStyle(

                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── QR Code Card ────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _kPurpleBorder, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: _kPurpleLight.withOpacity(0.10),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Dark header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 20,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1A2A4A),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(19),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.qr_code_2_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'THAI QR PAYMENT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                    child: Column(
                      children: [
                        // PromptPay label
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.contactless_rounded,
                                color: Color(0xFF1A5276),
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'PromptPay',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                  color: Color(0xFF1A5276),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // QR Code Image — decorative placeholder styled like real PromptPay QR
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: const Color(0xFFEEEEEE),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                Icons.qr_code_2_rounded,
                                size: 180,
                                color: Colors.black87,
                              ),
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: _kPurple,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.store_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Account name
                        Text(
                          s.scanToTransfer,
                          style: const TextStyle(
                            color: _kPurple,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'บริษัท เมริมาริ (ประเทศไทย) จำกัด\nMERIMARI (THAILAND) CO., LTD',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: _kText,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'xxx-x-x0637-x',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'เลขที่อ้างอิง 004666008841177',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Footer
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8F8F8),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(19),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Accepts all banks · รับเงินได้จากทุกธนาคาร',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Slip Upload / Pay Later ────────────────────────────────

              // Upload slip button
              GestureDetector(
                onTap: _uploading ? null : _handleUploadPressed,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: _kPurpleFaint,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _kPurpleBorder, width: 1.5),
                  ),
                  child: _uploading
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: _uploadProgress > 0 ? _uploadProgress : null,
                                  backgroundColor: _kPurpleBorder,
                                  valueColor: const AlwaysStoppedAnimation<Color>(_kPurple),
                                  minHeight: 6,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _uploadProgress > 0
                                    ? '${(_uploadProgress * 100).toStringAsFixed(0)}%'
                                    : '...',
                                style: const TextStyle(
                                  color: _kPurple,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.upload_file_rounded,
                              color: _kPurple,
                              size: 22,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              s.uploadSlip,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: _kPurple,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              // Show selected slip preview
              if (_webImageBytes != null && !_uploading)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Container(
                    width: double.infinity,
                    height: 160,
                    decoration: BoxDecoration(
                      color: _kPurpleFaint.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _kPurple.withOpacity(0.2)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.image_search_rounded,
                          color: _kPurple,
                          size: 48,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          s.slipUploaded, // Changed from successLabel
                          style: const TextStyle(
                            color: _kPurple,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'marmari_slip_demo.png',
                          style: TextStyle(
                            color: _kPurple.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 12),

              // Pay Later button
              GestureDetector(
                onTap: () => _showPayLaterDialog(context, s),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _kPurpleBorder, width: 1.5),
                  ),
                  child: Center(
                    child: Text(
                      s.payLater,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: _kText,
                      ),
                    ),
                  ),
                ),
              ),


            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _showPayLaterDialog(BuildContext context, dynamic s) {
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
              Text(
                s.payLater,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                  color: _kText,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                s.payLaterNoticeMsg,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: _kText,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
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
                    onPressed: () => Navigator.pop(ctx),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                        ),
                      ),
                    ),
                    child: Text(
                      s.cancelLabel,
                      style: const TextStyle(
                        color: _kText,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Container(width: 1, height: 50, color: Colors.grey.shade200),
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      Navigator.pop(ctx);
                      if (_activeOrderId == null) {
                        final np = context.read<NotificationsProvider>();
                        // Place order in OrdersProvider (To Pay tab)
                        await context.read<OrdersProvider>().placeOrders(
                          items: widget.selectedItems
                              .map(
                                (ci) => {
                                  'itemId': (ci.item.id as String),
                                  'name': (ci.item.name as String),
                                  'price': (ci.item.price as double),
                                  'imageUrl': (ci.item.imageUrl as String),
                                  'qty': (ci.quantity as int),
                                },
                              )
                              .toList(),
                          tab: OrderTab.toPay,
                          np: np,
                          customTitleTh: 'จองสินค้าสำเร็จ',
                          customTitleEn: 'Reservation Successful',
                          customMsgTh: 'คุณได้ทำการจองสินค้าเรียบร้อยแล้ว รอการชำระเงิน',
                          customMsgEn: 'Product reserved successfully. Awaiting payment.',
                        );
                        if (!mounted) return;
                        final ordersProvider = context.read<OrdersProvider>();
                        if (ordersProvider.orders.isNotEmpty) {
                          _activeOrderId = ordersProvider.orders.last.id;
                        }
                        context.read<CartProvider>().clear();
                      }
                      if (!mounted) return;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const OrdersScreen(initialTab: 0),
                        ),
                        (route) => route.isFirst,
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                    ),
                    child: Text(
                      s.confirmLabel,
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
  }
}
