import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdRewarded {
  late RewardedAd _rewardedAd;

  Future<void> populateRewardedAd({
    required String adUnitId,
    AdSize? size,
  }) async {
    try {
      final adCompleter = Completer<RewardedAd>();
      await RewardedAd.load(
          adUnitId: adUnitId,
          request: const AdRequest(),
          rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (Ad ad) {
              debugPrint('RewardedAdListener onAdLoaded ${ad.toString()}.');
              adCompleter.complete(ad as RewardedAd);
              ad.fullScreenContentCallback = FullScreenContentCallback(
                onAdDismissedFullScreenContent: (ad) {
                  ad.dispose();
                },
              );
            },
            onAdFailedToLoad: (LoadAdError error) {
              debugPrint('RewardedAdListener onAdFailedToLoad: $error');
              adCompleter.completeError(error);
            },
          ));
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
}
