//จุดเริ่มต้นแอป
import 'package:flutter/material.dart';
import 'splash_screen.dart'; // <--- บรรทัดนี้จะไปเรียกหน้า Splash Screen ที่เราเพิ่งสร้างมาครับ

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MeriMariApp());
}

class MeriMariApp extends StatelessWidget {
  const MeriMariApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meri-Mari',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF673AB7),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      // สั่งให้แอปเปิดมาหน้าแรกเป็น Splash Screen เลย!
      home: const SplashScreen(), 
    );
  }
}