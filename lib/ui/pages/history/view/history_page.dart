import 'package:flutter/material.dart';
import 'package:qrcode/constant/static_variables.dart';
import 'package:qrcode/ui/widget/historyTab.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const int tabsCount = 2;

    return DefaultTabController(
        initialIndex: 0,
        length: tabsCount,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: TabBar(tabs: <Widget>[
                Tab(
                    icon: const Icon(Icons.qr_code_scanner),
                    text: StaticVariable.historyPagesTabs[0]),
                Tab(
                    icon: const Icon(Icons.qr_code),
                    text: StaticVariable.historyPagesTabs[1]),
              ]),
            ),
            body: TabBarView(children: [
              HistoryTab(type: 0),
              HistoryTab(type: 1)
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
