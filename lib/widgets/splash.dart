import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({
    super.key,
    required this.showProgress,
  });

  final bool showProgress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffED5434),
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            color: Colors.transparent,
          ),
          const SizedBox(height: 40),
          SizedBox(
            height: 300,
            child: Image.asset(
              'Assets/splash.png',
              width: MediaQuery.of(context).size.width * 0.6,
            ),
          ),
          const SizedBox(height: 40),
          const CircularProgressIndicator(
            color: Colors.transparent,
          ),
        ],
      )),
    );
  }
}
