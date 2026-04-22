// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'providers/item_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/app_locale_provider.dart';
import 'providers/address_provider.dart';
import 'providers/orders_provider.dart';
import 'providers/notifications_provider.dart';

import 'firebase_options.dart';
import 'splash_screen.dart';
import 'features/landing_page.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    usePathUrlStrategy();
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ItemProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => AppLocaleProvider()),
        ChangeNotifierProvider(create: (_) => AddressProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
        ChangeNotifierProvider(create: (_) => NotificationsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // ตัวแปรเช็คว่าเป็นการโหลดครั้งแรกจากเบราว์เซอร์หรือไม่
  bool _isFirstLoad = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meri Mari',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFAB9DC4),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'sans-serif',
        scaffoldBackgroundColor: Colors.white,
      ),
      onGenerateRoute: (settings) {
        String? routeName = settings.name;

        // เช็ค URL จริงจาก Browser เฉพาะครั้งแรกที่แอปเริ่มทำงานบน Web
        if (kIsWeb && _isFirstLoad) {
          _isFirstLoad = false;
          final currentPath = Uri.base.path;
          if (currentPath == '/landing-page') {
            routeName = '/landing-page';
          }
        }

        if (routeName == '/landing-page') {
          return MaterialPageRoute(
            settings: const RouteSettings(name: '/landing-page'),
            builder: (_) => const LandingPage(),
          );
        }
        
        // สำหรับหน้าอื่นๆ หรือเมื่อกดจากปุ่มใน Landing Page
        return MaterialPageRoute(
          settings: const RouteSettings(name: '/'),
          builder: (_) => const SplashScreen(),
        );
      },
    );
  }
}
