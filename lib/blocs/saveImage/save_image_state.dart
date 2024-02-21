import 'package:equatable/equatable.dart';
import 'package:qrcode/model/history_model.dart';

class SaveImageState extends Equatable {
  @override
  List<Object> get props => [];
}

class SaveImageNotSave extends SaveImageState {}

class SaveImageLoading extends SaveImageState {}

class SaveImageSaved extends SaveImageState {}

class SaveImageError extends SaveImageState {
  final message;
  SaveImageError(this.message);
}
