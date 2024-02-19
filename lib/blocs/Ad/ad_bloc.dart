import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:qrcode/blocs/Ad/ad_event.dart';
import 'package:qrcode/blocs/Ad/ad_state.dart';
import 'package:qrcode/utils/Ads/AdsClient.dart';

class AdsBloc extends Bloc<AdBannerEvent, AdState> {
  AdsBloc() : super(const AdState()) {
    on<AdBannerRequestEvent>(_adBannerRequestEventHandler);
    on<AdBannerDisposeEvent>(_adBannerDisposeEventHandler);
    on<AdNativeRequestEvent>(_adNativeRequestEventHandler);
    on<AdNativeDisposeEvent>(_adNativeDisposeEventHandler);
  }
  final AdsClient _adsClient = AdsClient();

  Future<void> _adBannerRequestEventHandler(
      AdBannerRequestEvent event, Emitter<AdState> emit) async {
    emit(AdLoading());
    try {
      final result = await _adsClient.getPageBannerAd();
      emit(state.copyWith(bottomBannerAd: result));
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
    emit(AdLoading());
    try {
      final result = await _adsClient.getPageNativeAd();
      emit(state.copyWith(nativeAd: result));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _adNativeDisposeEventHandler(
      AdNativeDisposeEvent event, Emitter<AdState> emit) async {
    state.nativeAd?.dispose();
    emit(state.copyWithoutNativeAd());
  }
}
