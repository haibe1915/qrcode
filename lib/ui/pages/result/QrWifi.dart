import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/properties/address.dart';
import 'package:flutter_contacts/properties/note.dart';
import 'package:flutter_contacts/properties/phone.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qrcode/constant/static_variables.dart';
import 'package:qrcode/model/history_model.dart';
import 'package:qrcode/ui/pages/convert/convert_function/TextToQR.dart';
import 'package:qrcode/ui/widget/titleBar.dart';

class QrWifiPage extends StatefulWidget {
  QrWifiPage({super.key, required this.historyItem, this.controller});

  final HistoryItem historyItem;
  QRViewController? controller;

  @override
  State<QrWifiPage> createState() => _QrWifiPageState();
}

class _QrWifiPageState extends State<QrWifiPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Map<String, String> extractWifiData(String wifiData) {
    RegExp regExpS = RegExp(r"S:([^;]+)");
    String? valueS = regExpS.firstMatch(wifiData)?.group(1);

    RegExp regExpT = RegExp(r"T:([^;]+)");
    String? valueT = regExpT.firstMatch(wifiData)?.group(1);

    RegExp regExpP = RegExp(r"P:([^;]+)");
    String? valueP = regExpP.firstMatch(wifiData)?.group(1);

    Map<String, String> values = {};
    values["wifi"] = valueS!;
    values["password"] = valueT!;
    values["type"] = valueP!;
    return values;
  }

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Map<String, String> wifi = extractWifiData(widget.historyItem.content);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (widget.controller != null) {
              widget.controller!.resumeCamera();
            }
            Navigator.of(context).pop();
          },
        ),
        title: Text('Liên hệ'),
        actions: [
          IconButton(
            padding:
                const EdgeInsets.only(left: 10, top: 20, bottom: 20, right: 10),
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
                    QRCodeWidget _qrCodeWidget =
                        QRCodeWidget(data: widget.historyItem.content);
                    return AlertDialog(
                      content: SizedBox(
                        width: 200, // Adjust the width as needed
                        height: 200, // Adjust the height as needed
                        child: _qrCodeWidget,
                      ),
                      actions: [
                        TextButton(
                          child: const Text('Save'),
                          onPressed: () async {
                            _qrCodeWidget.saveImageToGallery();
                          },
                        ),
                        TextButton(
                          child: const Text('Close'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
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
            TitleBar(screenWidth: screenWidth, widget: widget),
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(top: 20),
              child: Card(
                elevation: 4,
                clipBehavior: Clip.hardEdge,
                child: Container(
                  width: screenWidth * 0.8,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Wifi:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: 5),
                        child: Text(
                          wifi["wifi"]!,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: 15),
                        child: Text(
                          'Password:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: 5),
                        child: Text(
                          wifi["password"]!,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: 15),
                        child: Text(
                          'Security type:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: 5),
                        child: Text(
                          wifi["type"]!,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
