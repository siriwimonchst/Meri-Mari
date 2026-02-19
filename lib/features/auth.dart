// lib/features/auth.dart
import 'package:flutter/material.dart';
import 'home.dart'; // import หน้า home เพื่อให้กด login แล้วเด้งไปหน้า home

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Controller สำหรับรับค่าจากช่องกรอกข้อความ
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // ฟังก์ชันจำลองการกดปุ่ม Login
  void _login() {
    // ในอนาคตคุณสามารถใส่เงื่อนไขเช็ค Email/Password หรือเชื่อม Firebase ตรงนี้ได้
    // ตอนนี้เราให้มันกดแล้วข้ามไปหน้า Home เลยเพื่อทดสอบ UI
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // โลโก้หรือไอคอน
                const Icon(
                  Icons.lock_person_rounded,
                  size: 100,
                  color: Colors.purple, // ใช้สีม่วงให้เข้ากับธีม
                ),
                const SizedBox(height: 24),
                
                // ข้อความต้อนรับ
                const Text(
                  'Welcome to Meri Mari',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sign in to continue',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 40),

                // ช่องกรอก Email
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ช่องกรอก Password
                TextField(
                  controller: _passwordController,
                  obscureText: true, // ปิดบังรหัสผ่านเป็นจุดๆ
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ปุ่ม Login
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white, // สีตัวหนังสือในปุ่ม
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ปุ่มสมัครสมาชิก (จำลอง)
                TextButton(
                  onPressed: () {
                    // โค้ดสำหรับลิงก์ไปหน้า Register 
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('กำลังไปหน้าสมัครสมาชิก...')),
                    );
                  },
                  child: const Text(
                    'Don\'t have an account? Sign up',
                    style: TextStyle(color: Colors.purple),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // เคลียร์ค่าตัวแปรเมื่อออกจากหน้านี้เพื่อคืนหน่วยความจำ
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}