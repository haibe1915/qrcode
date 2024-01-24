import 'package:equatable/equatable.dart';
import 'package:qrcode/model/history_model.dart';

class SearchState extends Equatable {
  @override
  List<Object> get props => [];
}

class SearchStateNotLoaded extends SearchState {}

class SearchStateLoading extends SearchState {}

class SearchStateLoaded extends SearchState {
  final int type;
  final String str;
  final List<HistoryItem> dataList;
  SearchStateLoaded(this.type, this.str, this.dataList);
}

class SearchStateError extends SearchState {
  final message;
  SearchStateError(this.message);
}
