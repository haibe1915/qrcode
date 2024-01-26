import 'package:flutter/material.dart';
import 'package:qrcode/ui/homePage.dart';

class QrApp extends MaterialApp {
  const QrApp({super.key})
      : super(
            debugShowCheckedModeBanner: false,
            home: const HomePage(title: 'QrApp'));
}
