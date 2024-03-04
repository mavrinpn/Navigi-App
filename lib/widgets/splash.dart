import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffED5434),
      body: Center(
          child: Image.asset(
        'Assets/splash.png',
        width: MediaQuery.of(context).size.width * 0.6,
      )),
    );
  }
}
