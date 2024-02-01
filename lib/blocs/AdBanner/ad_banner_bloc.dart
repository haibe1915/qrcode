import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qrcode/blocs/AdBanner/ad_banner_event.dart';
import 'package:qrcode/blocs/AdBanner/ad_banner_state.dart';
import 'package:qrcode/utils/Ads/AdsClient.dart';

class AdsBloc extends Bloc<AdBannerEvent, AdBannerState> {
  AdsBloc() : super(const AdBannerState()) {
    on<AdBannerRequestEvent>(_adBannerRequestEventHandler);
    on<AdBannerDisposeEvent>(_adBannerDisposeEventHandler);
  }
  final AdsClient _adsClient = AdsClient();

  Future<void> _adBannerRequestEventHandler(
      AdBannerRequestEvent event, Emitter<AdBannerState> emit) async {
    try {
      final result = await _adsClient.getPageBannerAd();
      emit(state.copyWith(bottomBannerAd: result));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _adBannerDisposeEventHandler(
      AdBannerDisposeEvent event, Emitter<AdBannerState> emit) async {
    state.bottomBannerAd?.dispose();
    emit(state.copyWithoutBottomBannerAd());
  }
}
