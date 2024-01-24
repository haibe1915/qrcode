import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrcode/ui/homePage.dart';

class QrApp extends MaterialApp {
  const QrApp({super.key})
      : super(
            debugShowCheckedModeBanner: false,
            home: const HomePage(title: 'QrApp'));
}
