import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qrcode/blocs/Ad/ad_bloc.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    StaticVariable.interstitialAd
        .populateInterstitialAd(adUnitId: StaticVariable.adInterstitialId);
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
      //StaticVariable.interstitialAd.loadInterstitialAd();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Provider<AdsBloc>(
      create: (rootContext) => AdsBloc(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Scaffold(
              body: StaticVariable.pages[_currentPageIndex],
              bottomNavigationBar: BottomNavigationBar(
                selectedItemColor:
                    Colors.blueGrey, // Set the color for selected item
                unselectedItemColor: Colors.grey,
                selectedLabelStyle: const TextStyle(color: Colors.blueGrey),
                currentIndex: _currentPageIndex,
                onTap: (int index) {
                  setState(() {
                    _currentPageIndex = index;
                  });
                },
                selectedIconTheme: const IconThemeData(
                    color: Colors.blueGrey), // Set the color for selected icons
                unselectedIconTheme: const IconThemeData(color: Colors.grey),
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.access_time,
                      ),
                      label: 'History'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.qr_code_scanner), label: 'Qr'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.qr_code_outlined), label: 'Convert'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.settings), label: 'Setting'),
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
      ),
    );
  }
}
