import 'package:flutter/material.dart';

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
      // โค้ดสำหรับเปลี่ยนหน้าจอ (ตอนนี้ให้เด้งไปหน้า DummyLoginScreen ก่อน)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DummyLoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // สีพื้นหลังหน้า Splash Screen
      body: Center(
        child: Image.asset(
          'assets/logo_mm2.jpg', // ดึงรูปโลโก้ที่เราเพิ่งใส่มาโชว์
          width: 350, // ปรับขนาดความใหญ่ของโลโก้ได้ตามใจชอบครับ
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// หน้าจอสมมติ (Dummy) สำหรับให้มันเด้งไปหา 
// (เดี๋ยวเราค่อยเอาหน้า Login ของจริงที่คุณมิสาสร้างไว้มาเปลี่ยนใส่ทีหลังครับ)
class DummyLoginScreen extends StatelessWidget {
  const DummyLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'ล็อคอินเข้าสู่ระบบ Meri-Mari',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}