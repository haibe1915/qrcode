import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qrcode/blocs/Ad/ad_bloc.dart';
import 'package:qrcode/constant/static_variables.dart';
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
    if (state == AppLifecycleState.paused) {
      StaticVariable.interstitialAd.loadInterstitialAd();
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
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: Container(
                  margin: const EdgeInsets.all(10),
                  height: 64,
                  width: 64,
                  child: FloatingActionButton(
                    backgroundColor: Colors.blueGrey,
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
                      Icons.qr_code_scanner,
                      size: 35,
                      color: Colors.white,
                    ),
                  )),
              bottomNavigationBar: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: BottomNavigationBar(
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
                      color:
                          Colors.blueGrey), // Set the color for selected icons
                  unselectedIconTheme: const IconThemeData(color: Colors.grey),
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                        icon: const Icon(
                          Icons.access_time,
                        ),
                        label: 'history'.tr()),
                    const BottomNavigationBarItem(
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        label: ''),
                    BottomNavigationBarItem(
                        icon: const Icon(Icons.qr_code_outlined),
                        label: 'convert'.tr()),
                  ],
                ),
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
