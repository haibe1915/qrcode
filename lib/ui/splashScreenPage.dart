import 'package:flutter/material.dart';
import 'package:qrcode/ui/homePage.dart';

class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(child: Image.asset('assets/screen/Qr_splash_screen.png')));
  }
}
