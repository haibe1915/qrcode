import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:qrcode/model/history_model.dart';

class SearchEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SearchEventLoadData extends SearchEvent {
  final String str;
  final int type;
  final List<HistoryItem> historyList;
  SearchEventLoadData(
      {required this.str, required this.type, required this.historyList});
}

class SearchEventPopSearch extends SearchEvent {}
