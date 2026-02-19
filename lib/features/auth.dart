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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. ใช้พื้นหลังสีม่วงอ่อนสุดๆ เพื่อให้สบายตาและดูมินิมอล
      backgroundColor: Colors.deepPurple.shade50,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 2. ตกแต่งไอคอนโลโก้ให้ดูมีมิติ (มีเงาและกรอบวงกลมสีขาว)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.lock_person_rounded,
                    size: 80,
                    color: Colors.deepPurple.shade400,
                  ),
                ),
                const SizedBox(height: 32),
                
                // ข้อความต้อนรับ
                Text(
                  'Welcome to Meri Mari',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Colors.deepPurple.shade800,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to continue',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.deepPurple.shade300,
                  ),
                ),
                const SizedBox(height: 48),

                // 3. ช่องกรอก Email (ดีไซน์ใหม่ ไร้ขอบ พื้นหลังขาว)
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email Address',
                    prefixIcon: Icon(Icons.email_outlined, color: Colors.deepPurple.shade300),
                    filled: true,
                    fillColor: Colors.white, // พื้นหลังช่องกรอกสีขาว
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none, // เอาเส้นขอบแข็งๆ ออก
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.deepPurple.shade300, width: 2), // สีขอบตอนกดพิมพ์
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                ),
                const SizedBox(height: 16),

                // ช่องกรอก Password
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline, color: Colors.deepPurple.shade300),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.deepPurple.shade300, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                ),
                const SizedBox(height: 32),

                // 4. ปุ่ม Login (โค้งมนและมีเงา)
                Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple.shade600,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0, // ปิด elevation เดิมเพื่อใช้ BoxShadow แทนให้ดูนุ่มขึ้น
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ปุ่มสมัครสมาชิก
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('กำลังไปหน้าสมัครสมาชิก...')),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.deepPurple.shade400,
                  ),
                  child: const Text(
                    'Don\'t have an account? Sign up',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}