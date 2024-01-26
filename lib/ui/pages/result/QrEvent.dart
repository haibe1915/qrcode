import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/properties/address.dart';
import 'package:flutter_contacts/properties/note.dart';
import 'package:flutter_contacts/properties/phone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qrcode/constant/static_variables.dart';
import 'package:qrcode/model/history_model.dart';
import 'package:qrcode/ui/pages/convert/convert_function/TextToQR.dart';
import 'package:add_2_calendar/add_2_calendar.dart';

class QrEventPage extends StatefulWidget {
  QrEventPage({super.key, required this.historyItem, this.controller});

  final HistoryItem historyItem;
  QRViewController? controller;

  @override
  State<QrEventPage> createState() => _QrEventPageState();
}

class _QrEventPageState extends State<QrEventPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  _calendarPermissions() async {
    Map<Permission, PermissionStatus> permissionStatus =
        await [Permission.calendarFullAccess].request();
    return permissionStatus[Permission.calendarFullAccess];
  }

  addEvent(Map<String, String> event) async {
    PermissionStatus calendarPermissionsStatus = await _calendarPermissions();

    if (calendarPermissionsStatus.isGranted) {
      final Event tmp = Event(
          title: event["SUMMARY"]!,
          description: event["DESCRIPTION"]!,
          location: event["LOCATION"]!,
          startDate: DateTime.parse(event["DTSTART"]!),
          endDate: DateTime.parse(event["DTEND"]!));
      await Add2Calendar.addEvent2Cal(tmp).then((_) {
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
  }

  Map<String, String> extractICalendarValues(String iCalendarData) {
    iCalendarData = iCalendarData.trim();

    List<String> lines = iCalendarData.split('\n');
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
    Map<String, String> event =
        extractICalendarValues(widget.historyItem.content);
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
          title: Text('Sự kiện'),
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
                              addEvent(event);
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
                                  child: Text(event["SUMMARY"]!)),
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
                                  child: Text(event["DESCRIPTION"]!)),
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
                                  child: Text(event["LOCATION"]!)),
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
                                  child: Text(event["DTSTART"]!)),
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
                                  child: Text(event["DTEND"]!)),
                            ],
                          )))),
            ],
          ),
        ));
  }
}
