// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 1. Import Provider และหน้าจอเริ่มต้นของคุณเข้ามา (เช็ค Path ให้ตรงกับของคุณด้วยนะครับ)
import 'providers/item_provider.dart'; 
import 'splash_screen.dart'; // Path ของหน้า Splash Screen

void main() {
  runApp(
    // 2. ใช้ MultiProvider ครอบตัวแอปไว้ เพื่อให้ทุกหน้าจอเข้าถึงข้อมูลได้
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ItemProvider()),
        // ในอนาคตถ้ามี Provider อื่นๆ (เช่น EscrowProvider) ก็เอามาใส่ต่อตรงนี้ได้เลยครับ
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meri Mari',
      debugShowCheckedModeBanner: false, // เอาป้าย Debug มุมขวาบนออก
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      home: const SplashScreen(), // ตั้งค่าให้เริ่มแอปที่หน้า Splash Screen
    );
  }
}