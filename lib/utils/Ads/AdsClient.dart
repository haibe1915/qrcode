import 'dart:async';

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
