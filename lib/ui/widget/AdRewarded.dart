import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qrcode/utils/Ads/firebase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdRewarded {
  late RewardedAd _rewardedAd;

  Future<void> populateRewardedAd({
    required String adUnitId,
    AdSize? size,
  }) async {
    try {
      final adCompleter = Completer<RewardedAd>();
      void loadRewardedAd() async {
        await RewardedAd.load(
            adUnitId: adUnitId,
            request: const AdRequest(),
            rewardedAdLoadCallback: RewardedAdLoadCallback(
              onAdLoaded: (Ad ad) {
                logEvent(name: 'ad_reward_load_success', parameters: {});
                debugPrint('RewardedAdListener onAdLoaded ${ad.toString()}.');
                adCompleter.complete(ad as RewardedAd);
                ad.fullScreenContentCallback = FullScreenContentCallback(
                    onAdDismissedFullScreenContent: (ad) {
                  ad.dispose();
                }, onAdFailedToShowFullScreenContent: (ad, err) {
                  ad.dispose();
                }, onAdClicked: (ad) {
                  logEvent(
                      name: 'ads_reward_click', parameters: {'placement': ''});
                });
                ad.onPaidEvent = onPaidEvent;
              },
              onAdFailedToLoad: (LoadAdError error) async {
                await Future.delayed(const Duration(milliseconds: 350));
                logEvent(name: 'ad_reward_load_fail', parameters: {
                  'errormsg': error.message,
                  'code': error.code,
                  "mediationClassName": error.responseInfo != null
                      ? error.responseInfo!.mediationAdapterClassName != null
                          ? error.responseInfo!.mediationAdapterClassName!
                          : ''
                      : '',
                  "adapterResponses": error.responseInfo != null
                      ? error.responseInfo!.adapterResponses != null
                          ? error.responseInfo!.adapterResponses.toString()
                          : ''
                      : '',
                });
                loadRewardedAd();
              },
            ));
      }

      loadRewardedAd();
      _rewardedAd = await adCompleter.future;
    } catch (e) {
      throw e;
    }
  }

  Future<void> loadRewardedAd() async {
    final prefs = await SharedPreferences.getInstance();
    final lastAdTime = prefs.getInt("lastAdTimePreference");
    final now = DateTime.now().millisecondsSinceEpoch;
    if (lastAdTime != null && now - lastAdTime < 30000) {
      return;
    }
    prefs.setInt("lastAdTimePreference", DateTime.now().millisecondsSinceEpoch);
    debugPrint('RewardedAd show');
    return _rewardedAd.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {});
  }

  static void onPaidEvent(ad, valueMicros, precision, currencyCode) async {
    double valueInCurrency = valueMicros / 1e6;

    final FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics.instance;
    final adSource = ad.responseInfo.loadedAdapterResponseInfo.adSourceName;

    firebaseAnalytics.logEvent(
      name: 'ad_impression',
      parameters: {
        'ad_platform': 'admob',
        'ad_source': adSource,
        'ad_format': 'rewarded_video',
        'currency': currencyCode,
        'value': valueInCurrency,
      },
    );
  }
}
