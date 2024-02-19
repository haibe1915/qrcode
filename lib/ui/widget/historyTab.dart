import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrcode/blocs/search/search_bloc.dart';
import 'package:qrcode/blocs/search/search_event.dart';
import 'package:qrcode/blocs/search/search_state.dart';
import 'package:qrcode/constant/static_variables.dart';
import 'package:qrcode/model/history_model.dart';
import 'package:qrcode/ui/pages/result/QrContact.dart';
import 'package:qrcode/ui/pages/result/QrEmail.dart';
import 'package:qrcode/ui/pages/result/QrEvent.dart';
import 'package:qrcode/ui/pages/result/QrPhone.dart';
import 'package:qrcode/ui/pages/result/QrSms.dart';
import 'package:qrcode/ui/pages/result/QrText.dart';
import 'package:qrcode/ui/pages/result/QrUrl.dart';

class HistoryTab extends StatefulWidget {
  const HistoryTab({super.key, required this.type});
  final int type;

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

  void dispose() {
    sub!.cancel();
    super.dispose();
  }

  Future<void> listener() async {
    if (widget.type == 1) {
      sub = StaticVariable.createdController.stream.listen((historyItem) {
        StaticVariable.createdHistoryList.add(historyItem);
      });
    }
    if (widget.type == 0) {
      sub = StaticVariable.scannedController.stream.listen((historyItem) {
        StaticVariable.scannedHistoryList.add(historyItem);
      });
    }
  }

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

  String SmsText(String content) {
    final phoneNumberStartIndex = content.indexOf(':') + 1;
    final phoneNumberEndIndex = content.indexOf('?');
    final phoneNumber =
        content.substring(phoneNumberStartIndex, phoneNumberEndIndex);
    return phoneNumber;
  }

  String EmailText(String content) {
    final emailAddressStartIndex = content.indexOf(':') + 1;
    final emailAddressEndIndex = content.indexOf('?');
    final emailAddress =
        content.substring(emailAddressStartIndex, emailAddressEndIndex);
    return emailAddress;
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
      case 'tin nhắn':
        summary = SmsText(item.content);
        break;
      case 'email':
        summary = EmailText(item.content);
        break;
      default:
        summary = item.content;
    }
    if (summary.length > 30) return "${summary.substring(0, 30)}...";
    return summary;
  }

  Widget resultPage(HistoryItem historyItem) {
    if (historyItem.type == "url") {
      return QrUrlPage(historyItem: historyItem);
    } else if (historyItem.type == "sự kiện") {
      return QrEventPage(historyItem: historyItem);
    } else if (historyItem.type == "liên hệ") {
      return QrContactPage(historyItem: historyItem);
    } else if (historyItem.type == "điện thoại") {
      return QrPhonePage(historyItem: historyItem);
    } else if (historyItem.type == "tin nhắn") {
      return QrSmsPage(historyItem: historyItem);
    } else if (historyItem.type == "email") {
      return QrEmailPage(historyItem: historyItem);
    } else
      return QrTextPage(historyItem: historyItem);
  }

  Widget build(BuildContext context) {
    List<HistoryItem> historyList = widget.type == 0
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
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: search,
                  onChanged: (value) {},
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              BlocBuilder<SearchBloc, SearchState>(
                  bloc: _searchBloc,
                  builder: (context, state) {
                    if (state is SearchStateNotLoaded) {
                      return PopupMenuButton<int>(
                        initialValue: type,
                        onSelected: (int type) {
                          typeController.sink.add(type);
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
                          typeController.sink.add(type);
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
                child: BlocBuilder<SearchBloc, SearchState>(
                    bloc: _searchBloc,
                    builder: (context, state) {
                      if (state is SearchStateNotLoaded) {
                        return ListView.builder(
                          controller: _scrollController,
                          itemCount: historyList.length,
                          itemBuilder: (context, index) {
                            final HistoryItem historyItem =
                                historyList[historyList.length - index - 1];
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
                                      Expanded(
                                          child: ListTile(
                                        leading: StaticVariable
                                            .iconCategory[historyItem.type],
                                        title: Text(
                                            historyItem.datetime.toString()),
                                        subtitle:
                                            Text(HistoryItemText(historyItem)),
                                      )),
                                      IconButton(
                                          onPressed: () {
                                            print(historyItem.type);
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    content: const SizedBox(
                                                      width:
                                                          200, // Adjust the width as needed
                                                      height:
                                                          50, // Adjust the height as needed
                                                      child: Center(
                                                        child: Text(
                                                            "Bạn có muốn xoá không ?"),
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        child: const Text('Có'),
                                                        onPressed: () {
                                                          if (widget.type ==
                                                              0) {
                                                            StaticVariable.conn
                                                                .deleteScaned(
                                                                    historyItem
                                                                        .datetime);
                                                          } else if (widget
                                                                  .type ==
                                                              1) {
                                                            StaticVariable.conn
                                                                .deleteCreated(
                                                                    historyItem
                                                                        .datetime);
                                                          }
                                                          _searchBloc.add(
                                                              SearchEventDeleteData(
                                                                  str: "",
                                                                  type: 0,
                                                                  historyItem:
                                                                      historyItem,
                                                                  historyList:
                                                                      historyList));
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                      TextButton(
                                                        child:
                                                            const Text('Không'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                });
                                          },
                                          icon: const Icon(
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
                                      Expanded(
                                          child: ListTile(
                                        leading: StaticVariable
                                            .iconCategory[historyItem.type],
                                        title: Text(
                                            historyItem.datetime.toString()),
                                        subtitle:
                                            Text(HistoryItemText(historyItem)),
                                      )),
                                      IconButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    content: const SizedBox(
                                                      width:
                                                          200, // Adjust the width as needed
                                                      height:
                                                          100, // Adjust the height as needed
                                                      child: Text(
                                                          "Bạn có muốn xoá không ?"),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        child: const Text('Có'),
                                                        onPressed: () {
                                                          if (widget.type ==
                                                              0) {
                                                            StaticVariable.conn
                                                                .deleteScaned(
                                                                    historyItem
                                                                        .datetime);
                                                          } else if (widget
                                                                  .type ==
                                                              1) {
                                                            StaticVariable.conn
                                                                .deleteCreated(
                                                                    historyItem
                                                                        .datetime);
                                                          }
                                                          _searchBloc.add(
                                                              SearchEventDeleteData(
                                                                  str:
                                                                      state.str,
                                                                  type: state
                                                                      .type,
                                                                  historyItem:
                                                                      historyItem,
                                                                  historyList: state
                                                                      .dataList));
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                      TextButton(
                                                        child:
                                                            const Text('Không'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                });
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ))
                                    ],
                                  ),
                                ));
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
