import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qrcode/constant/static_variables.dart';
import 'package:qrcode/model/history_model.dart';
import 'package:qrcode/ui/pages/convert/convert_function/TextToQR.dart';
import 'package:url_launcher/url_launcher.dart';

class QrSmsPage extends StatefulWidget {
  QrSmsPage({super.key, required this.historyItem, this.controller});

  final HistoryItem historyItem;
  QRViewController? controller;

  @override
  State<QrSmsPage> createState() => _QrSmsPageState();
}

class _QrSmsPageState extends State<QrSmsPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Map<String, String> extractSmsStringValues(String smsString) {
    final phoneNumberStartIndex = smsString.indexOf(':') + 1;
    final phoneNumberEndIndex = smsString.indexOf('?');
    final phoneNumber =
        smsString.substring(phoneNumberStartIndex, phoneNumberEndIndex);

    final messageStartIndex = smsString.indexOf('body=') + 5;
    final message =
        Uri.decodeQueryComponent(smsString.substring(messageStartIndex));

    Map<String, String> values = {};
    values["phone_number"] = phoneNumber;
    values["message"] = message;

    return values;
  }

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Map<String, String> contact =
        extractSmsStringValues(widget.historyItem.content);

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back), // Change the back button icon
            onPressed: () {
              if (widget.controller != null) {
                print("resume");
                widget.controller!.resumeCamera();
              }
              Navigator.of(context).pop();
            },
          ),
          title: Text('Tin nhắn'),
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
                  child: Column(
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          width: screenWidth * 0.7,
                          height: 20,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          margin:
                              EdgeInsets.only(left: 10, right: 10, bottom: 10),
                          child: Text(contact["phone_number"]!)),
                      Container(
                          alignment: Alignment.centerLeft,
                          width: screenWidth * 0.7,
                          height: 20,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          margin:
                              EdgeInsets.only(left: 10, right: 10, bottom: 10),
                          child: Text(contact["message"]!))
                    ],
                  )),
              Center(
                child: Center(
                  child: Container(
                      height: screenHeight * 0.1,
                      width: screenWidth * 0.4,
                      padding: EdgeInsets.only(top: 10),
                      child: Card(
                          elevation: 4,
                          child: InkWell(
                              onTap: () async {
                                launchUrl(
                                    Uri.parse(widget.historyItem.content));
                              },
                              child: Center(child: Text('Gửi'))))),
                ),
              )
            ],
          ),
        ));
  }
}
