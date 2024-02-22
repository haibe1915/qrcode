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
      final adCompleter = Completer<BannerAd>();

      final bannerAd = BannerAd(
        adUnitId: adUnitId,
        size: size ?? AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) {
            debugPrint('BannerAdListener onAdLoaded ${ad.toString()}.');
            adCompleter.complete(ad as BannerAd);
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            debugPrint('BannerAdListener onAdFailedToLoad: $error');
            ad.dispose();
            adCompleter.completeError(error);
          },
          // Add other listener callbacks if needed
        ),
      );

      await bannerAd.load();

      return await adCompleter.future;
    } catch (error) {
      throw error;
    }
  }

  Future<NativeAd> _populateNativeAd({
    required String adUnitId,
    AdSize? size,
  }) async {
    try {
      final adCompleter = Completer<NativeAd>();

      final nativeAd = NativeAd(
          adUnitId: adUnitId,
          request: const AdRequest(),
          listener: NativeAdListener(
            onAdLoaded: (Ad ad) {
              debugPrint('NativeAdListener onAdLoaded ${ad.toString()}.');
              adCompleter.complete(ad as NativeAd);
            },
            onAdFailedToLoad: (Ad ad, LoadAdError error) {
              debugPrint('NativeAdListener onAdFailedToLoad: $error');
              ad.dispose();
              adCompleter.completeError(error);
              return StaticVariable.defaultAdNative;
            },
          ),
          nativeTemplateStyle: NativeTemplateStyle(
              // Required: Choose a template.
              templateType: TemplateType.small,
              // Optional: Customize the ad's style.
              mainBackgroundColor: Colors.white,
              cornerRadius: 10.0,
              callToActionTextStyle: NativeTemplateTextStyle(
                  textColor: Colors.white,
                  backgroundColor: Colors.blue,
                  style: NativeTemplateFontStyle.monospace,
                  size: 16.0),
              primaryTextStyle: NativeTemplateTextStyle(
                  textColor: Colors.black,
                  //backgroundColor: Colors.cyan,
                  style: NativeTemplateFontStyle.italic,
                  size: 16.0),
              secondaryTextStyle: NativeTemplateTextStyle(
                  textColor: Colors.green,
                  backgroundColor: Colors.black,
                  style: NativeTemplateFontStyle.bold,
                  size: 16.0),
              tertiaryTextStyle: NativeTemplateTextStyle(
                  textColor: Colors.brown,
                  backgroundColor: Colors.amber,
                  style: NativeTemplateFontStyle.normal,
                  size: 16.0)));

      await nativeAd.load();

      return await adCompleter.future;
    } catch (error) {
      throw error;
    }
  }

  Future<BannerAd> getPageBannerAd() async {
    try {
      return await _populateBannerAd(adUnitId: StaticVariable.adBannerId);
    } catch (error) {
      throw error;
    }
  }

  Future<NativeAd> getPageNativeAd() async {
    try {
      return await _populateNativeAd(adUnitId: StaticVariable.adNativeId);
    } catch (error) {
      // Handle the error appropriately
      throw error;
    }
  }

  // Future<InterstitialAd> getPageInterstitialAd() async {
  //   try {
  //     return await _populateInterstitialAd(
  //         adUnitId: StaticVariable.adInterstitialId);
  //   } catch (error) {
  //     throw error;
  //   }
  // }
}
