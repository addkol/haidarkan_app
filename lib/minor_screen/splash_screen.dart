import 'dart:async';

import 'package:flutter/material.dart';
import 'package:haidarkan_app/main_screen/customer_home.dart';




class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 10));
    animation = CurvedAnimation(parent: controller, curve: Curves.linear);

    Timer(
        const Duration(seconds: 5),
            () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const CustomerHomeScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'assets/zastavka.gif',
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,

            ),
          )
        ],
      ),
    );
  }
}
