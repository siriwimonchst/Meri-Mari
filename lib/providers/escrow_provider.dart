//จัดการสถานะการเงินและการซื้อขาย
import 'package:flutter/material.dart';

enum OrderStatus { pending, paid, shipped, received, completed }

class EscrowProvider with ChangeNotifier {
  OrderStatus _currentStatus = OrderStatus.pending;

  OrderStatus get currentStatus => _currentStatus;

  // จำลองการจ่ายเงินเข้าระบบ Escrow
  void payOrder() {
    _currentStatus = OrderStatus.paid; // เงินถูกถือไว้ที่แอป
    notifyListeners();
  }

  // ผู้ซื้อกดยืนยันเพื่อโอนเงินให้ผู้ขาย
  void confirmReceived() {
    _currentStatus = OrderStatus.completed; // เงินถูกโอนให้ผู้ขาย
    notifyListeners();
  }
}