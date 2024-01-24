import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:qrcode/constant/static_variables.dart';
import 'package:qrcode/model/history_model.dart';
import 'package:qrcode/blocs/search/search_event.dart';
import 'package:qrcode/blocs/search/search_state.dart';
import 'package:qrcode/repositories/history_function/search.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  @override
  SearchBloc() : super(SearchStateNotLoaded()) {
    on<SearchEventLoadData>(_handleSearchEventLoadData);
    on<SearchEventDeleteData>(_handleSearchEventDeleteData);
  }
  Search _search = Search();

  void _handleSearchEventLoadData(
      SearchEventLoadData event, Emitter<SearchState> emit) async {
    if (event.str.isEmpty && event.type == 0) {
      emit(SearchStateNotLoaded());
    } else {
      emit(SearchStateLoading());
      try {
        List<HistoryItem> searchResult =
            _search.searchHistoryItem(event.str, event.historyList);
        if (event.type == 0) {
          searchResult.sort((a, b) => a.datetime.compareTo(b.datetime));
        } else if (event.type == 1) {
          searchResult.sort((a, b) => a.type.compareTo(b.type));
        }
        emit(SearchStateLoaded(event.type, event.str, searchResult));
      } catch (e) {
        emit(SearchStateError(e.toString()));
      }
    }
  }

  void _handleSearchEventDeleteData(
      SearchEventDeleteData event, Emitter<SearchState> emit) async {
    print(event.historyItem.datetime.toString());
    print(event.type);
    print(event.str);
    List<HistoryItem> deleteResult = event.historyList;
    deleteResult
        .removeWhere((item) => item.datetime == event.historyItem.datetime);
    StaticVariable.createdHistoryList
        .removeWhere((item) => item.datetime == event.historyItem.datetime);
    StaticVariable.scannedHistoryList
        .removeWhere((item) => item.datetime == event.historyItem.datetime);

    emit(SearchStateLoaded(event.type, event.str, deleteResult));
  }

  @override
  void onTransition(Transition<SearchEvent, SearchState> transition) {
    super.onTransition(transition);
    print(transition);
  }
}
