import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qrcode/constant/static_variables.dart';
import 'package:qrcode/model/history_model.dart';
import 'package:qrcode/ui/pages/convert/convert_function/TextToQR.dart';
import 'package:qrcode/ui/widget/titleBar.dart';
import 'package:url_launcher/url_launcher.dart';

class QrEmailPage extends StatefulWidget {
  QrEmailPage({super.key, required this.historyItem, this.controller});

  final HistoryItem historyItem;
  QRViewController? controller;

  @override
  State<QrEmailPage> createState() => _QrEmailPageState();
}

class _QrEmailPageState extends State<QrEmailPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Map<String, String> extractEmailStringValues(String emailString) {
    final emailAddressStartIndex = emailString.indexOf(':') + 1;
    final emailAddressEndIndex = emailString.indexOf('?');
    final emailAddress =
        emailString.substring(emailAddressStartIndex, emailAddressEndIndex);

    final subjectStartIndex = emailString.indexOf('subject=') + 8;
    final subjectEndIndex = emailString.indexOf('&', subjectStartIndex);
    final subject = Uri.decodeQueryComponent(
        emailString.substring(subjectStartIndex, subjectEndIndex));

    final bodyStartIndex = emailString.indexOf('body=') + 5;
    final body =
        Uri.decodeQueryComponent(emailString.substring(bodyStartIndex));

    Map<String, String> values = {};
    values["email"] = emailAddress;
    values["subject"] = subject;
    values["body"] = body;

    return values;
  }

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Map<String, String> contact =
        extractEmailStringValues(widget.historyItem.content);

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
                                  'Email:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(top: 5),
                                child: Text(
                                  contact["email"]!,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Chủ đề:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(top: 5),
                                child: Text(
                                  contact["subject"]!,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Nội dung:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(top: 5),
                                child: Text(
                                  contact["body"]!,
                                  style: TextStyle(fontSize: 16),
                                ),
                              )
                            ],
                          )))),
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
