import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrcode/constant/static_variables.dart';
import 'package:qrcode/ui/widget/LanguageOption.dart';
import 'package:qrcode/ui/widget/PremiumOption.dart';
import 'package:qrcode/ui/widget/historyTab.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key, required this.onLanguageChange});
  final Function() onLanguageChange;
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  void changeLanguage() {
    setState(() {});
    widget.onLanguageChange();
  }

  @override
  Widget build(BuildContext context) {
    const int tabsCount = 2;

    return DefaultTabController(
        initialIndex: 0,
        length: tabsCount,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const PremiumOption(),
                  const SizedBox(width: 10),
                  LanguageOption(
                    onLanguageChanged: changeLanguage,
                  )
                ],
              ),
              bottom: TabBar(
                  indicator: const UnderlineTabIndicator(
                    borderSide: BorderSide(
                      width: 4.0, // Width of the indicator line
                      color: Colors.blueGrey, // Color of the indicator line
                    ),
                  ),
                  labelColor: Colors.black,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  unselectedLabelColor: Colors.grey,
                  tabs: <Widget>[
                    Tab(
                        //iconMargin: const EdgeInsets.only(bottom: 5),
                        //icon: const Icon(Icons.qr_code_scanner),
                        text: 'scanned'.tr()),
                    Tab(
                        //iconMargin: const EdgeInsets.only(bottom: 5),
                        //icon: const Icon(Icons.qr_code),
                        text: 'created'.tr()),
                  ]),
            ),
            body: const TabBarView(children: [
              HistoryTab(type: "Scan"),
              HistoryTab(type: "Create")
              // Scaffold(
              //     body: Column(
              //   children: [
              //     Row(
              //       children: [
              //         Expanded(
              //           child: TextField(
              //             controller: scannedSearch,
              //             onChanged: (value) {},
              //             decoration: const InputDecoration(
              //               hintText: 'Search',
              //               prefixIcon: Icon(Icons.search),
              //             ),
              //           ),
              //         ),
              //         BlocBuilder<SearchBloc, SearchState>(
              //             bloc: _searchScannedBloc,
              //             builder: (context, state) {
              //               if (state is SearchStateNotLoaded) {
              //                 return PopupMenuButton<int>(
              //                   initialValue: typeScanned,
              //                   onSelected: (int type) {
              //                     typeCreatedController.sink.add(type);
              //                   },
              //                   itemBuilder: (BuildContext context) =>
              //                       <PopupMenuEntry<int>>[
              //                     const PopupMenuItem<int>(
              //                       value: 0,
              //                       child: Text('Thời gian'),
              //                     ),
              //                     const PopupMenuItem<int>(
              //                       value: 1,
              //                       child: Text('Thể loại'),
              //                     ),
              //                   ],
              //                 );
              //               } else if (state is SearchStateLoaded) {
              //                 return PopupMenuButton<int>(
              //                   initialValue: state.type,
              //                   onSelected: (int type) {
              //                     typeCreatedController.sink.add(type);
              //                   },
              //                   itemBuilder: (BuildContext context) =>
              //                       <PopupMenuEntry<int>>[
              //                     const PopupMenuItem<int>(
              //                       value: 0,
              //                       child: Text('Thời gian'),
              //                     ),
              //                     const PopupMenuItem<int>(
              //                       value: 1,
              //                       child: Text('Thể loại'),
              //                     ),
              //                   ],
              //                 );
              //               }
              //               return Container();
              //             })
              //       ],
              //     ),
              //     Expanded(
              //       child: Center(
              //         child: Container(
              //             child: BlocProvider<SearchBloc>(
              //           create: (context) => _searchScannedBloc,
              //           child: BlocBuilder<SearchBloc, SearchState>(
              //               bloc: _searchScannedBloc,
              //               builder: (context, state) {
              //                 if (state is SearchStateNotLoaded) {
              //                   return ListView.builder(
              //                     controller: _scrollController,
              //                     itemCount:
              //                         StaticVariable.scannedHistoryList.length,
              //                     itemBuilder: (context, index) {
              //                       final HistoryItem historyItem =
              //                           StaticVariable.scannedHistoryList[
              //                               StaticVariable
              //                                       .scannedHistoryList.length -
              //                                   index -
              //                                   1];
              //                       return InkWell(
              //                           onTap: () {
              //                             Navigator.push(
              //                               context,
              //                               MaterialPageRoute(
              //                                   builder: (context) =>
              //                                       resultPage(historyItem)),
              //                             );
              //                           },
              //                           child: Card(
              //                             child: Row(
              //                               children: [
              //                                 Expanded(
              //                                     child: ListTile(
              //                                   leading:
              //                                       StaticVariable.iconCategory[
              //                                           historyItem.type],
              //                                   title: Text(historyItem.datetime
              //                                       .toString()),
              //                                   subtitle: Text(HistoryItemText(
              //                                       historyItem)),
              //                                 )),
              //                                 IconButton(
              //                                     onPressed: () {
              //                                       print(historyItem.type);
              //                                       showDialog(
              //                                           context: context,
              //                                           builder: (BuildContext
              //                                               context) {
              //                                             return AlertDialog(
              //                                               content:
              //                                                   const SizedBox(
              //                                                 width:
              //                                                     200, // Adjust the width as needed
              //                                                 height:
              //                                                     50, // Adjust the height as needed
              //                                                 child: Center(
              //                                                   child: Text(
              //                                                       "Bạn có muốn xoá không ?"),
              //                                                 ),
              //                                               ),
              //                                               actions: [
              //                                                 TextButton(
              //                                                   child:
              //                                                       const Text(
              //                                                           'Có'),
              //                                                   onPressed: () {
              //                                                     StaticVariable
              //                                                         .conn
              //                                                         .deleteScaned(
              //                                                             historyItem
              //                                                                 .datetime);
              //                                                     _searchScannedBloc.add(SearchEventDeleteData(
              //                                                         str: "",
              //                                                         type: 0,
              //                                                         historyItem:
              //                                                             historyItem,
              //                                                         historyList:
              //                                                             StaticVariable
              //                                                                 .scannedHistoryList));
              //                                                     Navigator.of(
              //                                                             context)
              //                                                         .pop();
              //                                                   },
              //                                                 ),
              //                                                 TextButton(
              //                                                   child:
              //                                                       const Text(
              //                                                           'Không'),
              //                                                   onPressed: () {
              //                                                     Navigator.of(
              //                                                             context)
              //                                                         .pop();
              //                                                   },
              //                                                 ),
              //                                               ],
              //                                             );
              //                                           });
              //                                     },
              //                                     icon: const Icon(
              //                                       Icons.delete,
              //                                       color: Colors.red,
              //                                     ))
              //                               ],
              //                             ),
              //                           ));
              //                     },
              //                   );
              //                 } else if (state is SearchStateLoaded) {
              //                   return ListView.builder(
              //                     controller: _scrollController,
              //                     itemCount: state.dataList.length,
              //                     itemBuilder: (context, index) {
              //                       final HistoryItem historyItem =
              //                           state.dataList[index];
              //                       print(historyItem.type);
              //                       return InkWell(
              //                           onTap: () {
              //                             Navigator.push(
              //                               context,
              //                               MaterialPageRoute(
              //                                   builder: (context) =>
              //                                       resultPage(historyItem)),
              //                             );
              //                           },
              //                           child: Card(
              //                             child: Row(
              //                               children: [
              //                                 Expanded(
              //                                     child: ListTile(
              //                                   leading:
              //                                       StaticVariable.iconCategory[
              //                                           historyItem.type],
              //                                   title: Text(historyItem.datetime
              //                                       .toString()),
              //                                   subtitle: Text(HistoryItemText(
              //                                       historyItem)),
              //                                 )),
              //                                 IconButton(
              //                                     onPressed: () {
              //                                       showDialog(
              //                                           context: context,
              //                                           builder: (BuildContext
              //                                               context) {
              //                                             return AlertDialog(
              //                                               content:
              //                                                   const SizedBox(
              //                                                 width:
              //                                                     200, // Adjust the width as needed
              //                                                 height:
              //                                                     100, // Adjust the height as needed
              //                                                 child: Text(
              //                                                     "Bạn có muốn xoá không ?"),
              //                                               ),
              //                                               actions: [
              //                                                 TextButton(
              //                                                   child:
              //                                                       const Text(
              //                                                           'Có'),
              //                                                   onPressed: () {
              //                                                     StaticVariable
              //                                                         .conn
              //                                                         .deleteScaned(
              //                                                             historyItem
              //                                                                 .datetime);
              //                                                     _searchScannedBloc.add(SearchEventDeleteData(
              //                                                         str: state
              //                                                             .str,
              //                                                         type: state
              //                                                             .type,
              //                                                         historyItem:
              //                                                             historyItem,
              //                                                         historyList:
              //                                                             state
              //                                                                 .dataList));
              //                                                     Navigator.of(
              //                                                             context)
              //                                                         .pop();
              //                                                   },
              //                                                 ),
              //                                                 TextButton(
              //                                                   child:
              //                                                       const Text(
              //                                                           'Không'),
              //                                                   onPressed: () {
              //                                                     Navigator.of(
              //                                                             context)
              //                                                         .pop();
              //                                                   },
              //                                                 ),
              //                                               ],
              //                                             );
              //                                           });
              //                                     },
              //                                     icon: const Icon(
              //                                       Icons.delete,
              //                                       color: Colors.red,
              //                                     ))
              //                               ],
              //                             ),
              //                           ));
              //                     },
              //                   );
              //                 } else if (state is SearchStateLoading) {
              //                   return const Center(
              //                       child: CircularProgressIndicator());
              //                 } else if (state is SearchStateError) {
              //                   return Center(
              //                     child: Text(
              //                       state.message,
              //                       style: const TextStyle(color: Colors.red),
              //                     ),
              //                   );
              //                 }
              //                 return Container();
              //               }),
              //         )),
              //       ),
              //     ),
              //   ],
              // )),
              // Scaffold(
              //     body: Column(
              //   children: [
              //     Row(
              //       children: [
              //         Expanded(
              //           child: TextField(
              //             controller: createdSearch,
              //             onChanged: (value) {},
              //             decoration: const InputDecoration(
              //               hintText: 'Search',
              //               prefixIcon: Icon(Icons.search),
              //             ),
              //           ),
              //         ),
              //         BlocBuilder<SearchBloc, SearchState>(
              //             bloc: _searchScannedBloc,
              //             builder: (context, state) {
              //               if (state is SearchStateNotLoaded) {
              //                 return PopupMenuButton<int>(
              //                   initialValue: typeScanned,
              //                   onSelected: (int type) {
              //                     typeCreatedController.sink.add(type);
              //                   },
              //                   itemBuilder: (BuildContext context) =>
              //                       <PopupMenuEntry<int>>[
              //                     const PopupMenuItem<int>(
              //                       value: 0,
              //                       child: Text('Thời gian'),
              //                     ),
              //                     const PopupMenuItem<int>(
              //                       value: 1,
              //                       child: Text('Thể loại'),
              //                     ),
              //                   ],
              //                 );
              //               } else if (state is SearchStateLoaded) {
              //                 return PopupMenuButton<int>(
              //                   initialValue: state.type,
              //                   onSelected: (int type) {
              //                     typeCreatedController.sink.add(type);
              //                   },
              //                   itemBuilder: (BuildContext context) =>
              //                       <PopupMenuEntry<int>>[
              //                     const PopupMenuItem<int>(
              //                       value: 0,
              //                       child: Text('Thời gian'),
              //                     ),
              //                     const PopupMenuItem<int>(
              //                       value: 1,
              //                       child: Text('Thể loại'),
              //                     ),
              //                   ],
              //                 );
              //               }
              //               return Container();
              //             })
              //       ],
              //     ),
              //     Expanded(
              //       child: Center(
              //         child: Container(
              //             child: BlocProvider<SearchBloc>(
              //           create: (context) => _searchCreatedBloc,
              //           child: BlocBuilder<SearchBloc, SearchState>(
              //               bloc: _searchCreatedBloc,
              //               builder: (context, state) {
              //                 if (state is SearchStateNotLoaded) {
              //                   return ListView.builder(
              //                     controller: _scrollController,
              //                     itemCount:
              //                         StaticVariable.createdHistoryList.length,
              //                     itemBuilder: (context, index) {
              //                       final HistoryItem historyItem =
              //                           StaticVariable.createdHistoryList[
              //                               StaticVariable
              //                                       .createdHistoryList.length -
              //                                   index -
              //                                   1];
              //                       return InkWell(
              //                           onTap: () {
              //                             Navigator.push(
              //                               context,
              //                               MaterialPageRoute(
              //                                   builder: (context) =>
              //                                       resultPage(historyItem)),
              //                             );
              //                           },
              //                           child: Card(
              //                             child: Row(
              //                               children: [
              //                                 Expanded(
              //                                     child: ListTile(
              //                                   leading:
              //                                       StaticVariable.iconCategory[
              //                                           historyItem.type],
              //                                   title: Text(historyItem.datetime
              //                                       .toString()),
              //                                   subtitle: Text(HistoryItemText(
              //                                       historyItem)),
              //                                 )),
              //                                 IconButton(
              //                                     onPressed: () {
              //                                       showDialog(
              //                                           context: context,
              //                                           builder: (BuildContext
              //                                               context) {
              //                                             return AlertDialog(
              //                                               content:
              //                                                   const SizedBox(
              //                                                 width:
              //                                                     200, // Adjust the width as needed
              //                                                 height:
              //                                                     100, // Adjust the height as needed
              //                                                 child: Text(
              //                                                     "Bạn có muốn xoá không ?"),
              //                                               ),
              //                                               actions: [
              //                                                 TextButton(
              //                                                   child:
              //                                                       const Text(
              //                                                           'Có'),
              //                                                   onPressed: () {
              //                                                     StaticVariable
              //                                                         .conn
              //                                                         .deleteCreated(
              //                                                             historyItem
              //                                                                 .datetime);
              //                                                     _searchCreatedBloc.add(SearchEventDeleteData(
              //                                                         str: "",
              //                                                         type: 0,
              //                                                         historyItem:
              //                                                             historyItem,
              //                                                         historyList:
              //                                                             StaticVariable
              //                                                                 .createdHistoryList));
              //                                                     Navigator.of(
              //                                                             context)
              //                                                         .pop();
              //                                                   },
              //                                                 ),
              //                                                 TextButton(
              //                                                   child:
              //                                                       const Text(
              //                                                           'Không'),
              //                                                   onPressed: () {
              //                                                     Navigator.of(
              //                                                             context)
              //                                                         .pop();
              //                                                   },
              //                                                 ),
              //                                               ],
              //                                             );
              //                                           });
              //                                     },
              //                                     icon: const Icon(
              //                                       Icons.delete,
              //                                       color: Colors.red,
              //                                     ))
              //                               ],
              //                             ),
              //                           ));
              //                     },
              //                   );
              //                 } else if (state is SearchStateLoaded) {
              //                   return ListView.builder(
              //                     controller: _scrollController,
              //                     itemCount: state.dataList.length,
              //                     itemBuilder: (context, index) {
              //                       final HistoryItem historyItem =
              //                           state.dataList[index];
              //                       return InkWell(
              //                           onTap: () {
              //                             Navigator.push(
              //                               context,
              //                               MaterialPageRoute(
              //                                   builder: (context) =>
              //                                       resultPage(historyItem)),
              //                             );
              //                           },
              //                           child: Card(
              //                             child: Row(
              //                               children: [
              //                                 Expanded(
              //                                     child: ListTile(
              //                                   leading:
              //                                       StaticVariable.iconCategory[
              //                                           historyItem.type],
              //                                   title: Text(historyItem.datetime
              //                                       .toString()),
              //                                   subtitle: Text(HistoryItemText(
              //                                       historyItem)),
              //                                 )),
              //                                 IconButton(
              //                                     onPressed: () {
              //                                       showDialog(
              //                                           context: context,
              //                                           builder: (BuildContext
              //                                               context) {
              //                                             return AlertDialog(
              //                                               content:
              //                                                   const SizedBox(
              //                                                 width:
              //                                                     200, // Adjust the width as needed
              //                                                 height:
              //                                                     100, // Adjust the height as needed
              //                                                 child: Text(
              //                                                     "Bạn có muốn xoá không ?"),
              //                                               ),
              //                                               actions: [
              //                                                 TextButton(
              //                                                   child:
              //                                                       const Text(
              //                                                           'Có'),
              //                                                   onPressed: () {
              //                                                     StaticVariable
              //                                                         .conn
              //                                                         .deleteCreated(
              //                                                             historyItem
              //                                                                 .datetime);
              //                                                     _searchCreatedBloc.add(SearchEventDeleteData(
              //                                                         str: state
              //                                                             .str,
              //                                                         type: state
              //                                                             .type,
              //                                                         historyItem:
              //                                                             historyItem,
              //                                                         historyList:
              //                                                             state
              //                                                                 .dataList));
              //                                                     Navigator.of(
              //                                                             context)
              //                                                         .pop();
              //                                                   },
              //                                                 ),
              //                                                 TextButton(
              //                                                   child:
              //                                                       const Text(
              //                                                           'Không'),
              //                                                   onPressed: () {
              //                                                     Navigator.of(
              //                                                             context)
              //                                                         .pop();
              //                                                   },
              //                                                 ),
              //                                               ],
              //                                             );
              //                                           });
              //                                     },
              //                                     icon: const Icon(
              //                                       Icons.delete,
              //                                       color: Colors.red,
              //                                     ))
              //                               ],
              //                             ),
              //                           ));
              //                     },
              //                   );
              //                 } else if (state is SearchStateLoading) {
              //                   return const Center(
              //                       child: CircularProgressIndicator());
              //                 } else if (state is SearchStateError) {
              //                   return Center(
              //                     child: Text(
              //                       state.message,
              //                       style: const TextStyle(color: Colors.red),
              //                     ),
              //                   );
              //                 }
              //                 return Container();
              //               }),
              //         )),
              //       ),
              //     ),
              //   ],
              // ))
            ]),
          ),
        ));
  }
}
