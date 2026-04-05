import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io' as io;
import '../providers/app_locale_provider.dart';
import '../providers/cart_provider.dart';
import '../core/app_theme.dart';
import '../core/slip_upload_service.dart';
import 'orders.dart';
import '../providers/orders_provider.dart';

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
  io.File? _slipImage;
  Uint8List? _webImageBytes;
  bool _uploading = false;
  bool _uploaded  = false;
  double _uploadProgress = 0;
  String? _uploadError;

  // ── Slip upload using real Firebase Storage ─────────────────────────────
  Future<void> _pickSlip() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1000,
      maxHeight: 1000,
      imageQuality: 50,
    );
    
    if (pickedFile == null) return;
    
    final bytes = await pickedFile.readAsBytes();
    final s = context.read<AppLocaleProvider>().strings;

    // ── 1. Determine orderId (create order first if this is a new checkout) ──
    String? activeOrderId = widget.orderId;
    if (activeOrderId == null) {
      // Place the order now so we have an ID to attach the slip to
      await context.read<OrdersProvider>().placeOrders(
        items: widget.selectedItems
            .map((ci) => {
                  'itemId':   ci.item.id as String,
                  'name':     ci.item.name as String,
                  'price':    ci.item.price as double,
                  'imageUrl': ci.item.imageUrl as String,
                  'qty':      ci.quantity as int,
                })
            .toList(),
        tab: OrderTab.toPay,
        hasSlip: false, // will be updated after upload
      );
      // The provider stores orders in order of insertion; last == newest
      final ordersProvider = context.read<OrdersProvider>();
      activeOrderId = ordersProvider.orders.isNotEmpty
          ? ordersProvider.orders.last.id
          : null;
      if (!mounted) return;
      context.read<CartProvider>().clear();
    }

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
        orderId:   activeOrderId ?? 'unknown',
        onProgress: (p) {
          if (mounted) setState(() => _uploadProgress = p);
        },
      );

      if (!mounted) return;
      setState(() {
        _uploading = false;
        _uploaded  = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            s.isThai
                ? 'อัปโหลดสลิปสำเร็จ รอ Admin ตรวจสอบ'
                : 'Slip uploaded — awaiting admin verification.',
          ),
          backgroundColor: const Color(0xFF4CAF50),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        ),
      );

      // Navigate to the orders screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const OrdersScreen(initialTab: 0)),
        (route) => route.isFirst,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _uploading   = false;
        _uploadError = e.toString().replaceFirst('Exception: ', '');
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            s.isThai
                ? 'เกิดข้อผิดพลาด: $_uploadError'
                : 'Upload failed: $_uploadError',
          ),
          backgroundColor: kErrorRedDark,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
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
                    '฿${widget.total.toStringAsFixed(0)}',
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
                    color: _kPurpleLight.withValues(alpha: 0.10),
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
                            color: Colors.white.withValues(alpha: 0.15),
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
            if (!_uploaded) ...[
              // Upload slip button
              GestureDetector(
                onTap: _uploading ? null : _pickSlip,
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
              if ((kIsWeb ? _webImageBytes != null : _slipImage != null) && !_uploading)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: kIsWeb
                        ? Image.memory(
                            _webImageBytes!,
                            height: 160,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            _slipImage!,
                            height: 160,
                            fit: BoxFit.cover,
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
            ] else ...[
              // ── Waiting Verification State ───────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDF7ED),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFA5D6A7),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF4CAF50),
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      s.waitingVerification,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2E7D32),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      s.verifyingPaymentMsg,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.green.shade700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          s.payLater,
          style: const TextStyle(fontWeight: FontWeight.w800, color: _kText),
        ),
        content: Text(
          s.isThai
              ? 'คำสั่งซื้อจะถูกบันทึกไว้ คุณสามารถชำระเงินภายหลังได้ในหน้าออเดอร์'
              : 'Your order will be saved and you can pay later from the orders page.',
          style: const TextStyle(color: Colors.black54),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              s.cancelLabel,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _kPurple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              if (widget.orderId == null) {
                // Place order in OrdersProvider (To Pay tab)
                context.read<OrdersProvider>().placeOrders(
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
                );
                context.read<CartProvider>().clear();
              }
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const OrdersScreen(initialTab: 0),
                ),
                (route) => route.isFirst,
              );
            },
            child: Text(s.confirmLabel),
          ),
        ],
      ),
    );
  }
}
