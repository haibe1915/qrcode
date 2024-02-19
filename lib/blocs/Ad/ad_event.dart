import 'package:equatable/equatable.dart';

class AdBannerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AdBannerRequestEvent extends AdBannerEvent {}

class AdBannerDisposeEvent extends AdBannerEvent {}

class AdNativeRequestEvent extends AdBannerEvent {}

class AdNativeDisposeEvent extends AdBannerEvent {}
