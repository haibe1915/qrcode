import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:qrcode/constant/static_variables.dart';
import 'package:qrcode/model/history_model.dart';
import 'package:qrcode/ui/pages/convert/convert_function/TextToQR.dart';
import 'package:qrcode/ui/pages/convert/view/SegmentButtonWifi.dart';

class WifiToQrPage extends StatefulWidget {
  const WifiToQrPage({super.key});

  @override
  State<WifiToQrPage> createState() => _WifiToQrPageState();
}

class _WifiToQrPageState extends State<WifiToQrPage> {
  TextEditingController _ssidEditingController = TextEditingController();
  TextEditingController _passwordEditingController = TextEditingController();
  String result = "WPA";

  @override
  void dispose() {
    _ssidEditingController.dispose();
    _passwordEditingController.dispose();
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
          title: Text('Văn bản'),
          actions: [
            IconButton(
              padding: const EdgeInsets.only(
                  left: 10, top: 20, bottom: 20, right: 10),
              alignment: Alignment.bottomLeft,
              icon: const Icon(
                Icons.check,
                size: 24,
                color: Colors.white,
              ),
              onPressed: () {
                var data =
                    "WIFI:S:${_ssidEditingController.text};T:${result};P:${_passwordEditingController.text};;";
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Container(
                          width: 200, // Adjust the width as needed
                          height: 200, // Adjust the height as needed
                          child: QRCodeWidget(data: data),
                        ),
                        actions: [
                          TextButton(
                            child: Text('Close'),
                            onPressed: () {
                              _ssidEditingController.clear();
                              _passwordEditingController.clear();
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
                HistoryItem tmp = HistoryItem(
                    type: 'wifi', datetime: DateTime.now(), content: data);
                StaticVariable.createdController.add(tmp);
                StaticVariable.conn.insertCreated(tmp);
              },
            )
          ],
        ),
        body: Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(top: 20),
            child: Card(
                elevation: 4,
                clipBehavior: Clip.hardEdge,
                child: Container(
                    height: screenHeight * 0.4,
                    width: screenWidth * 0.8,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          margin:
                              EdgeInsets.only(left: 10, right: 10, bottom: 10),
                          child: TextField(
                            controller: _ssidEditingController,
                            decoration: InputDecoration(
                              hintText: 'SSID',
                              contentPadding: EdgeInsets.all(10),
                              border: InputBorder.none,
                            ),
                            maxLines: null,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          margin:
                              EdgeInsets.only(left: 10, right: 10, bottom: 10),
                          child: TextField(
                            controller: _passwordEditingController,
                            decoration: InputDecoration(
                              hintText: 'Mật khẩu',
                              contentPadding: EdgeInsets.all(10),
                              border: InputBorder.none,
                            ),
                            maxLines: null,
                          ),
                        ),
                        SegmentedButton<String>(
                          segments: const <ButtonSegment<String>>[
                            ButtonSegment<String>(
                                value: "WPA",
                                label: Text('WPA/WPA2'),
                                icon: Icon(Icons.calendar_view_day)),
                            ButtonSegment<String>(
                                value: "WEP",
                                label: Text('WEP'),
                                icon: Icon(Icons.calendar_view_week)),
                          ],
                          selected: <String>{result},
                          onSelectionChanged: (Set<String> newSelection) {
                            setState(() {
                              result = newSelection.first;
                            });
                          },
                        )
                      ],
                    )))));
  }
}
