import 'package:equatable/equatable.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AdBannerRequestEvent extends AdEvent {}

class AdBannerDisposeEvent extends AdEvent {}

class AdNativeRequestEvent extends AdEvent {
  final TemplateType tempType;
  String? factoryId;
  AdNativeRequestEvent({required this.tempType, this.factoryId});
}

class AdNativeDisposeEvent extends AdEvent {}

class AdInterstitialRequestEvent extends AdEvent {}

class AdInterstitialDisposeEvent extends AdEvent {}
