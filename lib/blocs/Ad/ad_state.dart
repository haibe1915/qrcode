import 'package:equatable/equatable.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState extends Equatable {
  const AdState({this.bottomBannerAd, this.nativeAd});
  final BannerAd? bottomBannerAd;
  final NativeAd? nativeAd;
  @override
  List<Object?> get props => [bottomBannerAd, nativeAd];

  bool get didBottomBannerAdLoad => bottomBannerAd != null;
  bool get didNativeAdLoad => nativeAd != null;

  AdState copyWith({BannerAd? bottomBannerAd, NativeAd? nativeAd}) {
    return AdState(
        bottomBannerAd: bottomBannerAd ?? this.bottomBannerAd,
        nativeAd: nativeAd ?? this.nativeAd);
  }

  AdState copyWithoutBottomBannerAd() {
    return AdState(
      nativeAd: nativeAd,
    );
  }

  AdState copyWithoutNativeAd() {
    return AdState(
      bottomBannerAd: bottomBannerAd,
    );
  }
}

class AdLoading extends AdState {}
