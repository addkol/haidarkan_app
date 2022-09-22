
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:haidarkan_app/auth/customer_login.dart';
import 'package:haidarkan_app/auth/customer_register.dart';
import 'package:haidarkan_app/minor_screen/forgot_password.dart';
import 'package:haidarkan_app/minor_screen/splash_screen.dart';
import 'package:haidarkan_app/provider/cart_provider.dart';
import 'package:haidarkan_app/provider/wish_provider.dart';
import 'package:provider/provider.dart';

import 'main_screen/customer_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => Cart()),
    ChangeNotifierProvider(create: (_) => Wish()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash_screen',
      routes: {
        '/splash_screen': (context) => const SplashPage(),
        '/customer_signup': (context) => const CustomerRegister(),
        '/customer_login': (context) => const CustomerLogin(),
        '/customer_home': (context) => const CustomerHomeScreen(),
      },
    );
  }
}

