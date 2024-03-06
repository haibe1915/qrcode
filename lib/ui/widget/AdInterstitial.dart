import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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
          ad.fullScreenContentCallback = const FullScreenContentCallback();
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
}
