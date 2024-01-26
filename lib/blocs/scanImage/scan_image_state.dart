import 'package:equatable/equatable.dart';
import 'package:qrcode/model/history_model.dart';

class ScanImageState extends Equatable {
  @override
  List<Object> get props => [];
}

class ScanImageNotScan extends ScanImageState {}

class ScanImageLoading extends ScanImageState {}

class ScanImageScaned extends ScanImageState {
  final HistoryItem tmp;
  ScanImageScaned(this.tmp);
}

class ScanImageCaptured extends ScanImageState {
  final String str;
  ScanImageCaptured(this.str);
}

class ScanImageError extends ScanImageState {
  final message;
  ScanImageError(this.message);
}
