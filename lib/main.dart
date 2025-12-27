import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'routes.dart'; // ✅ هذا الملف يجب أن يكون في نفس المجلد
import 'presentation/provider/blood_provider.dart';
import 'presentation/screens/intro_screen.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/sign_screen.dart';
import 'presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BloodProvider()),
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
      debugShowCheckedModeBanner: false,
      title: 'SmartCare - بنك الدم',
      theme: ThemeData(
        primarySwatch: Colors.red,
        useMaterial3: true,
      ),
      home: const IntroScreen(),
      routes: {
        AppRoutes.intro: (context) => const IntroScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.register: (context) =>  ModernSignUpScreen(),
        AppRoutes.dashboard: (context) => const HomeScreen(),
      },
    );
  }
}