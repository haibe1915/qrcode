import 'package:equatable/equatable.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdBannerState extends Equatable {
  const AdBannerState({
    this.bottomBannerAd,
  });
  final BannerAd? bottomBannerAd;
  @override
  List<Object?> get props => [bottomBannerAd];

  bool get didBottomBannerAdLoad => bottomBannerAd != null;

  AdBannerState copyWith({
    BannerAd? bottomBannerAd,
  }) {
    return AdBannerState(
      bottomBannerAd: bottomBannerAd ?? this.bottomBannerAd,
    );
  }

  AdBannerState copyWithoutBottomBannerAd() {
    return AdBannerState(
      bottomBannerAd: bottomBannerAd,
    );
  }
}
