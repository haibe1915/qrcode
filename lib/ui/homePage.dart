import 'package:flutter/material.dart';
import 'package:qrcode/constant/static_variables.dart';
import 'package:qrcode/ui/widget/AdBanner.dart';
import 'package:qrcode/ui/widget/AdInterstitial.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final _interstitialAd = AdInterstitial();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _interstitialAd.populateInterstitialAd(
        adUnitId: StaticVariable.adInterstitialId);
    //_adBannerSingleton.adBanner = StaticVariable.adBanner;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // final AdBannerSingleton _adBannerSingleton = AdBannerSingleton();
  int _currentPageIndex = 2;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _interstitialAd.loadInterstitialAd();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Scaffold(
            body: StaticVariable.pages[_currentPageIndex],
            bottomNavigationBar: BottomNavigationBar(
              selectedLabelStyle: const TextStyle(color: Colors.grey),
              currentIndex: _currentPageIndex,
              onTap: (int index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.access_time,
                      color: Colors.grey,
                    ),
                    label: 'History'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.qr_code_scanner, color: Colors.grey),
                    label: 'Qr'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.qr_code, color: Colors.grey),
                    label: 'Convert'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings, color: Colors.grey),
                    label: 'Setting'),
              ],
            ),
          ),
        ),
        Material(
          child: SizedBox(
            height: 50,
            child: StaticVariable.adBanner,
          ),
        ),
      ],
    );
  }
}
