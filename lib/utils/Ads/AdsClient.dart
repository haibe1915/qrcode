import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qrcode/constant/static_variables.dart';

class AdsClient {
  Future<BannerAd> _populateBannerAd({
    required String adUnitId,
    AdSize? size,
  }) async {
    try {
      final adCompleter = Completer<Ad?>();
      await BannerAd(
        adUnitId: adUnitId,
        size: size ?? AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdOpened: (Ad ad) {
            debugPrint(' BannerAdListener onAdOpened ${ad.toString()}.');
          },
          onAdClosed: (Ad ad) {
            debugPrint(' BannerAdListener onAdClosed ${ad.toString()}.');
          },
          onAdImpression: (Ad ad) {
            debugPrint(' BannerAdListener onAdImpression ${ad.toString()}.');
          },
          onAdWillDismissScreen: (Ad ad) {
            debugPrint(
                ' BannerAdListener onAdWillDismissScreen ${ad.toString()}.');
          },
          onPaidEvent: (
            Ad ad,
            double valueMicros,
            PrecisionType precision,
            String currencyCode,
          ) {
            debugPrint('BannerAdListener PaidEvent ${ad.toString()}.');
          },
          onAdLoaded: adCompleter.complete,
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            adCompleter.completeError(error);
          },
        ),
      ).load();

      final bannerAd = await adCompleter.future;
      return bannerAd as BannerAd;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<BannerAd> getPageBannerAd() async {
    try {
      return await _populateBannerAd(adUnitId: StaticVariable.adId);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(error, stackTrace);
    }
  }
}
