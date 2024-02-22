import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qrcode/blocs/Ad/ad_bloc.dart';
import 'package:qrcode/blocs/Ad/ad_event.dart';
import 'package:qrcode/blocs/Ad/ad_state.dart';
import 'package:qrcode/constant/static_variables.dart';

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
    return _interstitialAd.show();
  }
}
