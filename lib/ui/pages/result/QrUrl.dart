import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:qrcode/constant/static_variables.dart';
import 'package:qrcode/model/history_model.dart';
import 'package:qrcode/ui/pages/convert/convert_function/TextToQR.dart';

class QrUrlPage extends StatefulWidget {
  const QrUrlPage({super.key, required this.historyItem});

  final HistoryItem historyItem;

  @override
  State<QrUrlPage> createState() => _QrUrlPageState();
}

class _QrUrlPageState extends State<QrUrlPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          title: Text('Url'),
          actions: [
            IconButton(
              padding: const EdgeInsets.only(
                  left: 10, top: 20, bottom: 20, right: 10),
              alignment: Alignment.bottomLeft,
              icon: const Icon(
                Icons.qr_code,
                size: 24,
                color: Colors.white,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Container(
                          width: 200, // Adjust the width as needed
                          height: 200, // Adjust the height as needed
                          child: QRCodeWidget(data: widget.historyItem.content),
                        ),
                        actions: [
                          TextButton(
                            child: Text('Close'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: screenWidth * 0.8,
                margin: EdgeInsets.only(top: 20),
                child: Card(
                  elevation: 4,
                  child: Row(
                    children: [
                      Container(
                          width: 60,
                          child: Center(child: Text(widget.historyItem.type))),
                      Expanded(
                          child: ListTile(
                        title: Text(widget.historyItem.datetime.toString()),
                      ))
                    ],
                  ),
                ),
              ),
              Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(top: 20),
                  child: Card(
                      elevation: 4,
                      clipBehavior: Clip.hardEdge,
                      child: Container(
                          height: screenHeight * 0.4,
                          width: screenWidth * 0.8,
                          child: Container(
                              alignment: Alignment.centerLeft,
                              width: screenWidth * 0.7,
                              height: 20,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                              ),
                              margin: EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10),
                              child: Text(widget.historyItem.content))))),
            ],
          ),
        ));
  }
}
