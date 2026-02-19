import 'package:flutter/material.dart';
// อย่าลืม import ไฟล์ home.dart เข้ามาด้วย (ปรับ Path ให้ตรงกับโฟลเดอร์ของคุณนะครับ)
import 'features/home.dart'; 
import 'features/auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // ตั้งเวลาให้แสดงหน้านี้ 3 วินาที แล้วสั่งให้เปลี่ยนหน้า
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return; // ป้องกัน Error กรณีหน้าจอถูกปิดไปก่อน
      
      // เปลี่ยนเป้าหมายจาก DummyLoginScreen เป็น HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/logo_mm2.jpg', 
          width: 350, 
        ),
      ),
    );
  }
}