import 'package:flutter/material.dart';
import 'package:qrcode/constant/static_variables.dart';
import 'package:qrcode/ui/homePage.dart';

class QrApp extends MaterialApp {
  QrApp({super.key})
      : super(
            debugShowCheckedModeBanner: false,
            theme: StaticVariable.myTheme,
            home: const HomePage(title: 'QrApp'));
}
