import 'package:equatable/equatable.dart';

class AdBannerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AdBannerRequestEvent extends AdBannerEvent {}

class AdBannerDisposeEvent extends AdBannerEvent {}
