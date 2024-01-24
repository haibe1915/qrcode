import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/properties/address.dart';
import 'package:flutter_contacts/properties/note.dart';
import 'package:flutter_contacts/properties/phone.dart';
import 'package:qrcode/constant/static_variables.dart';
import 'package:qrcode/model/history_model.dart';
import 'package:qrcode/qr/view/pages/convert/convert_function/TextToQR.dart';

class QrContactPage extends StatefulWidget {
  const QrContactPage({super.key, required this.historyItem});

  final HistoryItem historyItem;

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
          title: Text('Văn bản'),
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
                            child: Text('Nhập'),
                            onPressed: () {
                              addContact(contact);
                            },
                          ),
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
                          width: screenWidth * 0.8,
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
                                  margin: EdgeInsets.only(
                                      left: 10, right: 10, bottom: 10),
                                  child: Text(contact["FN"]!)),
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
                                  margin: EdgeInsets.only(
                                      left: 10, right: 10, bottom: 10),
                                  child: Text(contact["TEL"]!))
                            ],
                          )))),
            ],
          ),
        ));
  }
}
