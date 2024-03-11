import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qrcode/blocs/Ad/ad_bloc.dart';
import 'package:qrcode/constant/static_variables.dart';
import 'package:qrcode/ui/pages/convert/view/convert_page.dart';
import 'package:qrcode/ui/pages/history/view/history_page.dart';
import 'package:qrcode/ui/pages/qr_code/view/qr_page.dart';
import 'package:qrcode/ui/widget/AdBanner.dart';
import 'package:qrcode/ui/widget/AdInterstitial.dart';
import 'package:easy_localization/easy_localization.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  late List<Widget> pages;

  void updateLanguage() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    pages = [
      HistoryPage(
        onLanguageChange: updateLanguage,
      ),
      const QrPage(),
      ConvertPage(onLanguageChange: updateLanguage),
    ];
    StaticVariable.interstitialAd
        .populateInterstitialAd(adUnitId: StaticVariable.adInterstitialId);
    // StaticVariable.rewardedAd
    //     .populateRewardedAd(adUnitId: StaticVariable.adRewarded);
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
    if (state == AppLifecycleState.paused) {
      //StaticVariable.interstitialAd.loadInterstitialAd();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Scaffold(
            body: pages[_currentPageIndex],
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Container(
                margin: const EdgeInsets.all(10),
                height: 64,
                width: 64,
                child: FloatingActionButton(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  elevation: 2,
                  onPressed: () {
                    setState(() {
                      _currentPageIndex = 1;
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Icon(
                    Icons.camera,
                    size: 35,
                    color: Colors.white,
                  ),
                )),
            bottomNavigationBar: Container(
              color: Colors.black,
              width: MediaQuery.of(context).size.width * 0.1,
              child: BottomNavigationBar(
                selectedItemColor: Theme.of(context)
                    .colorScheme
                    .primary, // Set the color for selected item
                unselectedItemColor: Colors.grey,
                selectedLabelStyle:
                    TextStyle(color: Theme.of(context).colorScheme.primary),
                currentIndex: _currentPageIndex,
                onTap: (int index) {
                  setState(() {
                    _currentPageIndex = index;
                  });
                },
                selectedIconTheme: IconThemeData(
                    color: Theme.of(context)
                        .colorScheme
                        .primary), // Set the color for selected icons
                unselectedIconTheme: const IconThemeData(color: Colors.grey),
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: const Icon(
                        Icons.access_time,
                      ),
                      label: 'history'.tr()),
                  const BottomNavigationBarItem(
                      icon: Icon(Icons.add, color: Colors.white, size: 0),
                      label: ''),
                  BottomNavigationBarItem(
                      icon: const Icon(Icons.qr_code_outlined),
                      label: 'qr generator'.tr()),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
