import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:qrcode/constant/static_variables.dart';
import 'package:qrcode/model/history_model.dart';
import 'package:qrcode/ui/pages/convert/convert_function/TextToQR.dart';
import 'package:qrcode/blocs/search/search_bloc.dart';
import 'package:qrcode/blocs/search/search_event.dart';
import 'package:qrcode/blocs/search/search_state.dart';
import 'package:qrcode/ui/pages/result/QrContact.dart';
import 'package:qrcode/ui/pages/result/QrEvent.dart';
import 'package:qrcode/ui/pages/result/QrPhone.dart';
import 'package:qrcode/ui/pages/result/QrText.dart';
import 'package:qrcode/ui/pages/result/QrUrl.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  StreamSubscription<HistoryItem>? subCreated;
  StreamSubscription<HistoryItem>? subScanned;
  StreamSubscription<String>? searchSub;
  ScrollController _scrollController = new ScrollController();

  SearchBloc _searchCreatedBloc = SearchBloc();
  SearchBloc _searchScannedBloc = SearchBloc();

  String EventText(String content) {
    String summary = "";
    RegExp regExp = RegExp(r"SUMMARY:(.*)");

    Match? match = regExp.firstMatch(content);
    if (match != null) {
      summary = match.group(1)!.trim();
    }
    return summary;
  }

  String ContactText(String content) {
    String summary = "";
    RegExp regExp = RegExp(r"FN:(.*)");

    Match? match = regExp.firstMatch(content);
    if (match != null) {
      summary = match.group(1)!.trim();
    }
    return summary;
  }

  String HistoryItemText(HistoryItem item) {
    String summary = "";
    switch (item.type) {
      case 'sự kiện':
        summary = EventText(item.content);
        break;
      case 'liên hệ':
        summary = ContactText(item.content);
        break;
      default:
        summary = item.content;
    }
    return summary;
  }

  Widget resultPage(HistoryItem historyItem) {
    if (historyItem.type == "url")
      return QrUrlPage(historyItem: historyItem);
    else if (historyItem.type == "sự kiện") {
      return QrEventPage(historyItem: historyItem);
    } else if (historyItem.type == "liên hệ") {
      return QrContactPage(historyItem: historyItem);
    } else if (historyItem.type == "điện thoại") {
      return QrPhonePage(historyItem: historyItem);
    } else
      return QrTextPage(historyItem: historyItem);
  }

  Future<void> listener() async {
    subCreated = StaticVariable.createdController.stream.listen((historyItem) {
      StaticVariable.createdHistoryList.add(historyItem);
    });
    subScanned = StaticVariable.scannedController.stream.listen((historyItem) {
      StaticVariable.scannedHistoryList.add(historyItem);
    });
  }

  @override
  void initState() {
    listener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const int tabsCount = 2;

    TextEditingController _createdSearch = TextEditingController();
    StreamController<int> _typeCreatedController =
        StreamController<int>.broadcast();
    int typeCreated = 0;
    _typeCreatedController.sink.add(0);
    _createdSearch.addListener(() {
      _searchCreatedBloc.add(SearchEventLoadData(
          str: _createdSearch.text,
          type: typeCreated,
          historyList: StaticVariable.createdHistoryList));
    });
    _typeCreatedController.stream.listen((typeChoosed) {
      print(typeChoosed);
      typeCreated = typeChoosed;
      _searchCreatedBloc.add(SearchEventLoadData(
          str: _createdSearch.text,
          type: typeChoosed,
          historyList: StaticVariable.createdHistoryList));
    });

    TextEditingController _scannedSearch = TextEditingController();
    StreamController<int> _typeScannedController =
        StreamController<int>.broadcast();
    int typeScanned = 0;
    _typeScannedController.sink.add(0);
    _scannedSearch.addListener(() {
      _searchScannedBloc.add(SearchEventLoadData(
          str: _scannedSearch.text,
          type: typeScanned,
          historyList: StaticVariable.scannedHistoryList));
    });
    _typeScannedController.stream.listen((typeChoosed) {
      print(typeChoosed);
      typeScanned = typeChoosed;
      _searchScannedBloc.add(SearchEventLoadData(
          str: _createdSearch.text,
          type: typeChoosed,
          historyList: StaticVariable.scannedHistoryList));
    });

    return DefaultTabController(
        initialIndex: 0,
        length: tabsCount,
        child: Scaffold(
          appBar: AppBar(
            title: TabBar(tabs: <Widget>[
              Tab(text: StaticVariable.historyPagesTabs[0]),
              Tab(text: StaticVariable.historyPagesTabs[1]),
            ]),
          ),
          body: TabBarView(children: [
            Scaffold(
                body: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _createdSearch,
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          hintText: 'Search',
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                    BlocBuilder<SearchBloc, SearchState>(
                        bloc: _searchScannedBloc,
                        builder: (context, state) {
                          if (state is SearchStateNotLoaded) {
                            return PopupMenuButton<int>(
                              initialValue: typeScanned,
                              onSelected: (int type) {
                                _typeCreatedController.sink.add(type);
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<int>>[
                                const PopupMenuItem<int>(
                                  value: 0,
                                  child: Text('Thời gian'),
                                ),
                                const PopupMenuItem<int>(
                                  value: 1,
                                  child: Text('Thể loại'),
                                ),
                              ],
                            );
                          } else if (state is SearchStateLoaded) {
                            return PopupMenuButton<int>(
                              initialValue: state.type,
                              onSelected: (int type) {
                                _typeCreatedController.sink.add(type);
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<int>>[
                                const PopupMenuItem<int>(
                                  value: 0,
                                  child: Text('Thời gian'),
                                ),
                                const PopupMenuItem<int>(
                                  value: 1,
                                  child: Text('Thể loại'),
                                ),
                              ],
                            );
                          }
                          return Container();
                        })
                  ],
                ),
                Expanded(
                  child: Center(
                    child: Container(
                        child: BlocProvider<SearchBloc>(
                      create: (context) => _searchScannedBloc,
                      child: BlocBuilder<SearchBloc, SearchState>(
                          bloc: _searchScannedBloc,
                          builder: (context, state) {
                            if (state is SearchStateNotLoaded) {
                              return ListView.builder(
                                controller: _scrollController,
                                itemCount:
                                    StaticVariable.scannedHistoryList.length,
                                itemBuilder: (context, index) {
                                  final HistoryItem historyItem = StaticVariable
                                          .scannedHistoryList[
                                      StaticVariable.scannedHistoryList.length -
                                          index -
                                          1];
                                  return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  resultPage(historyItem)),
                                        );
                                      },
                                      child: Card(
                                        child: Row(
                                          children: [
                                            Container(
                                                width: 60,
                                                child: Center(
                                                    child: Text(
                                                        historyItem.type))),
                                            Expanded(
                                                child: ListTile(
                                              title: Text(historyItem.datetime
                                                  .toString()),
                                              subtitle: Text(
                                                  HistoryItemText(historyItem)),
                                            )),
                                            IconButton(
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          content: Container(
                                                            width:
                                                                200, // Adjust the width as needed
                                                            height:
                                                                100, // Adjust the height as needed
                                                            child: Text(
                                                                "Bạn có muốn xoá không ?"),
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              child: Text('Có'),
                                                              onPressed: () {
                                                                StaticVariable
                                                                    .conn
                                                                    .deleteScaned(
                                                                        historyItem
                                                                            .datetime);
                                                                _searchScannedBloc.add(SearchEventDeleteData(
                                                                    str: "",
                                                                    type: 0,
                                                                    historyItem:
                                                                        historyItem,
                                                                    historyList:
                                                                        StaticVariable
                                                                            .scannedHistoryList));
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                            TextButton(
                                                              child:
                                                                  Text('Close'),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      });
                                                },
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ))
                                          ],
                                        ),
                                      ));
                                },
                              );
                            } else if (state is SearchStateLoaded) {
                              return ListView.builder(
                                controller: _scrollController,
                                itemCount: state.dataList.length,
                                itemBuilder: (context, index) {
                                  final HistoryItem historyItem =
                                      state.dataList[index];
                                  print(historyItem.type);
                                  return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  resultPage(historyItem)),
                                        );
                                      },
                                      child: Card(
                                        child: Row(
                                          children: [
                                            Container(
                                                width: 60,
                                                child: Center(
                                                    child: Text(
                                                        historyItem.type))),
                                            Expanded(
                                                child: ListTile(
                                              title: Text(historyItem.datetime
                                                  .toString()),
                                              subtitle: Text(
                                                  HistoryItemText(historyItem)),
                                            )),
                                            IconButton(
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          content: Container(
                                                            width:
                                                                200, // Adjust the width as needed
                                                            height:
                                                                100, // Adjust the height as needed
                                                            child: Text(
                                                                "Bạn có muốn xoá không ?"),
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              child: Text('Có'),
                                                              onPressed: () {
                                                                StaticVariable
                                                                    .conn
                                                                    .deleteScaned(
                                                                        historyItem
                                                                            .datetime);
                                                                _searchScannedBloc.add(SearchEventDeleteData(
                                                                    str: state
                                                                        .str,
                                                                    type: state
                                                                        .type,
                                                                    historyItem:
                                                                        historyItem,
                                                                    historyList:
                                                                        state
                                                                            .dataList));
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                            TextButton(
                                                              child:
                                                                  Text('Close'),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      });
                                                },
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ))
                                          ],
                                        ),
                                      ));
                                },
                              );
                            } else if (state is SearchStateLoading) {
                              return Center(child: CircularProgressIndicator());
                            } else if (state is SearchStateError) {
                              return Center(
                                child: Text(
                                  state.message,
                                  style: TextStyle(color: Colors.red),
                                ),
                              );
                            }
                            return Container();
                          }),
                    )),
                  ),
                ),
              ],
            )),
            Scaffold(
                body: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _createdSearch,
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          hintText: 'Search',
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                    BlocBuilder<SearchBloc, SearchState>(
                        bloc: _searchScannedBloc,
                        builder: (context, state) {
                          if (state is SearchStateNotLoaded) {
                            return PopupMenuButton<int>(
                              initialValue: typeScanned,
                              onSelected: (int type) {
                                _typeCreatedController.sink.add(type);
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<int>>[
                                const PopupMenuItem<int>(
                                  value: 0,
                                  child: Text('Thời gian'),
                                ),
                                const PopupMenuItem<int>(
                                  value: 1,
                                  child: Text('Thể loại'),
                                ),
                              ],
                            );
                          } else if (state is SearchStateLoaded) {
                            return PopupMenuButton<int>(
                              initialValue: state.type,
                              onSelected: (int type) {
                                _typeCreatedController.sink.add(type);
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<int>>[
                                const PopupMenuItem<int>(
                                  value: 0,
                                  child: Text('Thời gian'),
                                ),
                                const PopupMenuItem<int>(
                                  value: 1,
                                  child: Text('Thể loại'),
                                ),
                              ],
                            );
                          }
                          return Container();
                        })
                  ],
                ),
                Expanded(
                  child: Center(
                    child: Container(
                        child: BlocProvider<SearchBloc>(
                      create: (context) => _searchCreatedBloc,
                      child: BlocBuilder<SearchBloc, SearchState>(
                          bloc: _searchCreatedBloc,
                          builder: (context, state) {
                            if (state is SearchStateNotLoaded) {
                              return ListView.builder(
                                controller: _scrollController,
                                itemCount:
                                    StaticVariable.createdHistoryList.length,
                                itemBuilder: (context, index) {
                                  final HistoryItem historyItem = StaticVariable
                                          .createdHistoryList[
                                      StaticVariable.createdHistoryList.length -
                                          index -
                                          1];
                                  return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  resultPage(historyItem)),
                                        );
                                      },
                                      child: Card(
                                        child: Row(
                                          children: [
                                            Container(
                                                width: 60,
                                                child: Center(
                                                    child: Text(
                                                        historyItem.type))),
                                            Expanded(
                                                child: ListTile(
                                              title: Text(historyItem.datetime
                                                  .toString()),
                                              subtitle: Text(
                                                  HistoryItemText(historyItem)),
                                            )),
                                            IconButton(
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          content: Container(
                                                            width:
                                                                200, // Adjust the width as needed
                                                            height:
                                                                100, // Adjust the height as needed
                                                            child: Text(
                                                                "Bạn có muốn xoá không ?"),
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              child: Text('Có'),
                                                              onPressed: () {
                                                                StaticVariable
                                                                    .conn
                                                                    .deleteScaned(
                                                                        historyItem
                                                                            .datetime);
                                                                _searchScannedBloc.add(SearchEventDeleteData(
                                                                    str: "",
                                                                    type: 0,
                                                                    historyItem:
                                                                        historyItem,
                                                                    historyList:
                                                                        StaticVariable
                                                                            .createdHistoryList));
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                            TextButton(
                                                              child:
                                                                  Text('Close'),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      });
                                                },
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ))
                                          ],
                                        ),
                                      ));
                                },
                              );
                            } else if (state is SearchStateLoaded) {
                              return ListView.builder(
                                controller: _scrollController,
                                itemCount: state.dataList.length,
                                itemBuilder: (context, index) {
                                  final HistoryItem historyItem =
                                      state.dataList[index];
                                  print(historyItem.type);
                                  return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  resultPage(historyItem)),
                                        );
                                      },
                                      child: Card(
                                        child: Row(
                                          children: [
                                            Container(
                                                width: 60,
                                                child: Center(
                                                    child: Text(
                                                        historyItem.type))),
                                            Expanded(
                                                child: ListTile(
                                              title: Text(historyItem.datetime
                                                  .toString()),
                                              subtitle: Text(
                                                  HistoryItemText(historyItem)),
                                            )),
                                            IconButton(
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          content: Container(
                                                            width:
                                                                200, // Adjust the width as needed
                                                            height:
                                                                100, // Adjust the height as needed
                                                            child: Text(
                                                                "Bạn có muốn xoá không ?"),
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              child: Text('Có'),
                                                              onPressed: () {
                                                                StaticVariable
                                                                    .conn
                                                                    .deleteScaned(
                                                                        historyItem
                                                                            .datetime);
                                                                _searchScannedBloc.add(SearchEventDeleteData(
                                                                    str: state
                                                                        .str,
                                                                    type: state
                                                                        .type,
                                                                    historyItem:
                                                                        historyItem,
                                                                    historyList:
                                                                        state
                                                                            .dataList));
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                            TextButton(
                                                              child:
                                                                  Text('Close'),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      });
                                                },
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ))
                                          ],
                                        ),
                                      ));
                                },
                              );
                            } else if (state is SearchStateLoading) {
                              return Center(child: CircularProgressIndicator());
                            } else if (state is SearchStateError) {
                              return Center(
                                child: Text(
                                  state.message,
                                  style: TextStyle(color: Colors.red),
                                ),
                              );
                            }
                            return Container();
                          }),
                    )),
                  ),
                ),
              ],
            ))
          ]),
        ));
  }

  @override
  void dispose() {
    subCreated?.cancel();
    subScanned?.cancel();
    super.dispose();
  }
}
