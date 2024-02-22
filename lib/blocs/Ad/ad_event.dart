import 'package:equatable/equatable.dart';

class AdEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AdBannerRequestEvent extends AdEvent {}

class AdBannerDisposeEvent extends AdEvent {}

class AdNativeRequestEvent extends AdEvent {}

class AdNativeDisposeEvent extends AdEvent {}

class AdInterstitialRequestEvent extends AdEvent {}

class AdInterstitialDisposeEvent extends AdEvent {}
