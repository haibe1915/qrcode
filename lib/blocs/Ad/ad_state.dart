import 'package:equatable/equatable.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState extends Equatable {
  const AdState({this.bottomBannerAd, this.nativeAd, this.interstitialAd});
  final BannerAd? bottomBannerAd;
  final NativeAd? nativeAd;
  final InterstitialAd? interstitialAd;
  @override
  List<Object?> get props => [bottomBannerAd, nativeAd, interstitialAd];

  bool get didBottomBannerAdLoad => bottomBannerAd != null;
  bool get didNativeAdLoad => nativeAd != null;
  bool get didInterstitialAdLoad => interstitialAd != null;

  AdState copyWith(
      {BannerAd? bottomBannerAd,
      NativeAd? nativeAd,
      InterstitialAd? interstitialAd}) {
    return AdState(
        bottomBannerAd: bottomBannerAd ?? this.bottomBannerAd,
        nativeAd: nativeAd ?? this.nativeAd,
        interstitialAd: interstitialAd ?? this.interstitialAd);
  }

  AdState copyWithoutBottomBannerAd() {
    return AdState(nativeAd: nativeAd, interstitialAd: interstitialAd);
  }

  AdState copyWithoutNativeAd() {
    return AdState(
        bottomBannerAd: bottomBannerAd, interstitialAd: interstitialAd);
  }

  AdState copyWithoutInterstitialAd() {
    return AdState(bottomBannerAd: bottomBannerAd, nativeAd: nativeAd);
  }
}

class AdLoading extends AdState {}
