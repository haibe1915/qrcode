import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:qrcode/blocs/Ad/ad_event.dart';
import 'package:qrcode/blocs/Ad/ad_state.dart';
import 'package:qrcode/constant/static_variables.dart';
import 'package:qrcode/utils/Ads/AdsClient.dart';

class AdsBloc extends Bloc<AdEvent, AdState> {
  AdsBloc() : super(const AdState()) {
    on<AdBannerRequestEvent>(_adBannerRequestEventHandler);
    on<AdBannerDisposeEvent>(_adBannerDisposeEventHandler);
    on<AdNativeRequestEvent>(_adNativeRequestEventHandler);
    on<AdNativeDisposeEvent>(_adNativeDisposeEventHandler);
  }
  final AdsClient _adsClient = AdsClient();

  Future<void> _adBannerRequestEventHandler(
      AdBannerRequestEvent event, Emitter<AdState> emit) async {
    try {
      if (!StaticVariable.premiumState) {
        final result = await _adsClient.getPageBannerAd();
        emit(state.copyWith(bottomBannerAd: result));
      } else {
        emit(state.copyWith());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _adBannerDisposeEventHandler(
      AdBannerDisposeEvent event, Emitter<AdState> emit) async {
    state.bottomBannerAd?.dispose();
    emit(state.copyWithoutBottomBannerAd());
  }

  Future<void> _adNativeRequestEventHandler(
      AdNativeRequestEvent event, Emitter<AdState> emit) async {
    try {
      if (!StaticVariable.premiumState) {
        final result = await _adsClient.getPageNativeAd(event.tempType);
        emit(state.copyWith(nativeAd: result));
      } else {
        emit(state.copyWith());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _adNativeDisposeEventHandler(
      AdNativeDisposeEvent event, Emitter<AdState> emit) async {
    state.nativeAd?.dispose();
    emit(state.copyWithoutNativeAd());
  }

  // Future<void> _adInterstitialRequestEventHandler(
  //     AdInterstitialRequestEvent event, Emitter<AdState> emit) async {
  //   try {
  //     final result = await _adsClient.getPageInterstitialAd();
  //     emit(state.copyWith(interstitialAd: result));
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  // }

  // Future<void> _adInterstitialDisposeEventHandler(
  //     AdInterstitialDisposeEvent event, Emitter<AdState> emit) async {
  //   state.interstitialAd?.dispose();
  //   emit(state.copyWithoutInterstitialAd());
  // }
}
