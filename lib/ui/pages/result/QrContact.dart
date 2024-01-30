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

class QrContactPage extends StatefulWidget {
  QrContactPage({super.key, required this.historyItem, this.controller});

  final HistoryItem historyItem;
  QRViewController? controller;

  @override
  State<QrContactPage> createState() => _QrContactPageState();
}

class _QrContactPageState extends State<QrContactPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  addContact(Map<String, String> contact) async {
    final newContact = Contact()
      ..name.first = contact["FN"]!
      ..phones = [Phone(contact["TEL"]!)];
    await newContact.insert().then((_) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Container(
                width: 200, // Adjust the width as needed
                height: 100, // Adjust the height as needed
                child: Center(child: Text('Thêm thành công')),
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
    });
  }

  Map<String, String> extractcontactStringValues(String contactString) {
    contactString = contactString.trim();

    List<String> lines = contactString.split('\n');

    Map<String, String> values = {};

    for (String line in lines) {
      List<String> parts = line.split(':');

      if (parts.length == 2) {
        String key = parts[0].trim();
        String value = parts[1].trim();

        values[key] = value;
      }
    }

    return values;
  }

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Map<String, String> contact =
        extractcontactStringValues(widget.historyItem.content);

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
                          'Họ tên:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: 5),
                        child: Text(
                          contact["FN"]!,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: 15),
                        child: Text(
                          'Số điện thoại:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: 5),
                        child: Text(
                          contact["TEL"]!,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Container(
                height: screenHeight * 0.06,
                width: screenWidth * 0.4,
                child: ElevatedButton(
                  onPressed: () async {
                    addContact(contact);
                  },
                  child: Text('Thêm'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
