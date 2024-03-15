import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qrcode/utils/Ads/firebase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdInterstitial {
  late InterstitialAd _interstitialAd;

  Future<void> populateInterstitialAd({
    required String adUnitId,
  }) async {
    final adCompleter = Completer<InterstitialAd>();

    await InterstitialAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
          debugPrint('InterstitialAdListener onAdLoaded ${ad.toString()}.');
          ad.fullScreenContentCallback =
              FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
          }, onAdFailedToShowFullScreenContent: (ad, err) {
            ad.dispose();
          }, onAdClicked: (ad) {
            // logEvent(
            //     name: 'ads_interstitial_click', parameters: {'placement': ''});
          });
          ad.onPaidEvent = onPaidEvent;
          adCompleter.complete(ad);
        }, onAdFailedToLoad: (LoadAdError error) {
          debugPrint('NativeAdListener onAdFailedToLoad: $error');
          adCompleter.completeError(error);
        }));
    _interstitialAd = await adCompleter.future;
  }

  Future<void> loadInterstitialAd() async {
    final prefs = await SharedPreferences.getInstance();
    final lastAdTime = prefs.getInt("lastAdTimePreference");
    final now = DateTime.now().millisecondsSinceEpoch;
    if (lastAdTime != null && now - lastAdTime < 30000) {
      return;
    }
    prefs.setInt("lastAdTimePreference", DateTime.now().millisecondsSinceEpoch);
    return _interstitialAd.show();
  }

  static void onPaidEvent(ad, valueMicros, precision, currencyCode) async {
    // double valueInCurrency = valueMicros / 1e6;

    // final FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics.instance;
    // final adSource = ad.responseInfo.loadedAdapterResponseInfo.adSourceName;

    // firebaseAnalytics.logEvent(
    //   name: 'ad_impression',
    //   parameters: {
    //     'ad_platform': 'admob',
    //     'ad_source': adSource,
    //     'ad_format': 'inters',
    //     'currency': currencyCode,
    //     'value': valueInCurrency,
    //   },
    // );
  }
}
