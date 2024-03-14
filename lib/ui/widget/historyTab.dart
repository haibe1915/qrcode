import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:qrcode/blocs/Ad/ad_bloc.dart';
import 'package:qrcode/blocs/search/search_bloc.dart';
import 'package:qrcode/blocs/search/search_event.dart';
import 'package:qrcode/blocs/search/search_state.dart';
import 'package:qrcode/constant/static_variables.dart';
import 'package:qrcode/model/history_model.dart';
import 'package:qrcode/ui/widget/AdNative.dart';
import 'package:qrcode/ui/widget/HistoryCard.dart';

class HistoryTab extends StatefulWidget {
  const HistoryTab({super.key, required this.type});
  final String type;

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  late StreamSubscription<HistoryItem>? sub;
  final ScrollController _scrollController = ScrollController();

  final SearchBloc _searchBloc = SearchBloc();

  @override
  void initState() {
    listener();
    super.initState();
  }

  @override
  void dispose() {
    sub!.cancel();
    super.dispose();
  }

  Future<void> listener() async {
    if (widget.type == "Create") {
      sub = StaticVariable.createdController.stream.listen((historyItem) {
        StaticVariable.createdHistoryList.add(historyItem);
      });
    }
    if (widget.type == "Scan") {
      sub = StaticVariable.scannedController.stream.listen((historyItem) {
        StaticVariable.scannedHistoryList.add(historyItem);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget adNativeTemp = ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Center(
        child: Provider(
            create: (_) => AdsBloc(),
            builder: (context, child) {
              return AdNative(
                tempType: TemplateType.small,
                width: 0.94 * MediaQuery.of(context).size.width,
              );
            }),
      ),
    );
    List<HistoryItem> historyList = widget.type == "Scan"
        ? StaticVariable.scannedHistoryList
        : StaticVariable.createdHistoryList;
    TextEditingController search = TextEditingController();
    StreamController<int> typeController = StreamController<int>.broadcast();
    int type = 0;
    typeController.sink.add(0);
    search.addListener(() {
      _searchBloc.add(SearchEventLoadData(
          str: search.text, type: type, historyList: historyList));
    });
    typeController.stream.listen((typeChoosed) {
      type = typeChoosed;
      _searchBloc.add(SearchEventLoadData(
          str: search.text, type: typeChoosed, historyList: historyList));
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 5),
            child: Row(
              children: [
                const SizedBox(width: 20),
                Expanded(
                  child: Card(
                    elevation: 2,
                    child: TextField(
                      controller: search,
                      onChanged: (value) {},
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: Theme.of(context).primaryColor,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Card(
                  elevation: 2,
                  child: BlocBuilder<SearchBloc, SearchState>(
                      bloc: _searchBloc,
                      builder: (context, state) {
                        if (state is SearchStateNotLoaded) {
                          return PopupMenuButton<int>(
                            icon: Icon(
                              Icons.calendar_month,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            initialValue: type,
                            onSelected: (int type) {
                              typeController.sink.add(type);
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<int>>[
                              PopupMenuItem<int>(
                                value: 0,
                                child: Text(
                                  'time',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ).tr(),
                              ),
                              PopupMenuItem<int>(
                                value: 1,
                                child: Text('type',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor))
                                    .tr(),
                              ),
                            ],
                          );
                        } else if (state is SearchStateLoaded) {
                          return PopupMenuButton<int>(
                            offset: const Offset(0, 50),
                            icon: Icon(
                              state.type == 0
                                  ? Icons.calendar_month
                                  : Icons.type_specimen,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            initialValue: state.type,
                            onSelected: (int type) {
                              typeController.sink.add(type);
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<int>>[
                              PopupMenuItem<int>(
                                value: 0,
                                child: const Text('time').tr(),
                              ),
                              PopupMenuItem<int>(
                                value: 1,
                                child: const Text('type').tr(),
                              ),
                            ],
                          );
                        }
                        return Container();
                      }),
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),
          const SizedBox(
            height: 0,
          ),
          Expanded(
            child: SizedBox(
              width: 0.9 * MediaQuery.of(context).size.width,
              child: Center(
                child: BlocBuilder<SearchBloc, SearchState>(
                    bloc: _searchBloc,
                    builder: (context, state) {
                      DateFormat formattedDate = DateFormat('d MMMM',
                          Localizations.localeOf(context).languageCode);

                      DateTime getDate(DateTime datetime) {
                        DateTime dateOnly = DateTime(
                            datetime.year, datetime.month, datetime.day);
                        return dateOnly;
                      }

                      if (state is SearchStateNotLoaded) {
                        DateTime currentDate = DateTime(0, 0, 0);

                        Widget setNewTitleDate(HistoryItem historyItem) {
                          DateTime dateOnly = getDate(historyItem.datetime);
                          if (currentDate != dateOnly) {
                            currentDate = dateOnly;
                            return Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    formattedDate.format(currentDate),
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Theme.of(context).primaryColor),
                                  ).tr(),
                                ],
                              ),
                            );
                          }
                          return Container();
                        }

                        return ListView.builder(
                          controller: _scrollController,
                          itemCount: historyList.length,
                          itemBuilder: (context, index) {
                            final HistoryItem historyItem =
                                historyList[historyList.length - index - 1];
                            return Column(
                              children: [
                                if (index != 0 && index % 10 == 0) adNativeTemp,
                                if (type == 0) setNewTitleDate(historyItem),
                                HistoryCard(
                                    historyItem: historyItem,
                                    type: widget.type,
                                    searchBloc: _searchBloc)
                              ],
                            );
                          },
                        );
                      } else if (state is SearchStateLoaded) {
                        DateTime currentDate = DateTime(0, 0, 0);
                        String currentType = "";

                        Widget setNewTitleDate(HistoryItem historyItem) {
                          DateTime dateOnly = getDate(historyItem.datetime);
                          if (currentDate != dateOnly) {
                            currentDate = dateOnly;
                            return Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    formattedDate.format(currentDate),
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Theme.of(context).primaryColor),
                                  ).tr(),
                                ],
                              ),
                            );
                          }
                          return Container();
                        }

                        Widget setNewTitleType(HistoryItem historyItem) {
                          if (currentType != historyItem.type) {
                            currentType = historyItem.type;
                            return Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    currentType,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Theme.of(context).primaryColor),
                                  ).tr(),
                                ],
                              ),
                            );
                          }
                          return Container();
                        }

                        return ListView.builder(
                          controller: _scrollController,
                          itemCount: state.dataList.length,
                          itemBuilder: (context, index) {
                            final HistoryItem historyItem =
                                state.dataList[index];
                            return Column(
                              children: [
                                if (index != 0 && index % 10 == 0) adNativeTemp,
                                if (type == 0) setNewTitleDate(historyItem),
                                if (type == 1) setNewTitleType(historyItem),
                                HistoryCard(
                                    historyItem: historyItem,
                                    type: widget.type,
                                    searchBloc: _searchBloc)
                              ],
                            );
                          },
                        );
                      } else if (state is SearchStateLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is SearchStateError) {
                        return Center(
                          child: Text(
                            state.message,
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      }
                      return Container();
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
