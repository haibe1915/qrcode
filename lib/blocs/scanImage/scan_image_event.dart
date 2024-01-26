import 'package:equatable/equatable.dart';

class ScanImageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ScanImageScan extends ScanImageEvent {}

class ScanImageCapture extends ScanImageEvent {
  final String str;
  ScanImageCapture(this.str);
}
