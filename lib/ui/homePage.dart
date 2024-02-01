import 'package:flutter/material.dart';
import 'package:qrcode/constant/static_variables.dart';
import 'package:qrcode/ui/widget/AdBanner.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          StaticVariable.pages[_currentPageIndex],
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SizedBox(
              height: 50,
              child: AdBanner(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.access_time), label: 'History'),
          BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner), label: 'Qr'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: 'Convert'),
        ],
      ),
    );
  }
}
