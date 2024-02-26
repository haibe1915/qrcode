import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qrcode/blocs/Ad/ad_bloc.dart';
import 'package:qrcode/constant/static_variables.dart';
import 'package:qrcode/model/history_model.dart';
import 'package:qrcode/ui/widget/QRCodeWidget.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:qrcode/ui/widget/AdNative.dart';
import 'package:qrcode/ui/widget/titleBar.dart';

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

  DateTime _convertString(String dateString) {
    int year = int.parse(dateString.substring(0, 4));
    int month = int.parse(dateString.substring(4, 6));
    int day = int.parse(dateString.substring(6, 8));
    int hour = int.parse(dateString.substring(9, 11));
    int minute = int.parse(dateString.substring(11, 13));
    int second = int.parse(dateString.substring(13, 15));

    return DateTime(year, month, day, hour, minute, second);
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
                content: const SizedBox(
                  width: 200, // Adjust the width as needed
                  height: 100, // Adjust the height as needed
                  child: Center(child: Text('Thêm thành công')),
                ),
                actions: [
                  TextButton(
                    child: const Text('Close'),
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Map<String, String> event =
        extractICalendarValues(widget.historyItem.content);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (widget.controller != null) {
              print("resume");
              widget.controller!.resumeCamera();
            }
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Sự kiện'),
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
                    QRCodeWidget qrCodeWidget =
                        QRCodeWidget(data: widget.historyItem.content);
                    return AlertDialog(
                      content: SizedBox(
                        width: 200, // Adjust the width as needed
                        height: 200, // Adjust the height as needed
                        child: qrCodeWidget,
                      ),
                      actions: [
                        TextButton(
                          child: const Text('Save'),
                          onPressed: () async {
                            qrCodeWidget.saveImageToGallery();
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
      body: Column(
        children: [
          TitleBar(screenWidth: screenWidth, widget: widget),
          Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.only(top: 20),
            child: Card(
              elevation: 4,
              clipBehavior: Clip.hardEdge,
              child: Container(
                width: screenWidth * 0.8,
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Summary:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Text(
                        event["SUMMARY"]!,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Description:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Text(
                        event["DESCRIPTION"]!,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Location:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Text(
                        event["LOCATION"]!,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Start Time:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Text(
                        StaticVariable.formattedDateTime
                            .format(_convertString(event["DTSTART"]!))
                            .toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'End Time:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Text(
                        StaticVariable.formattedDateTime
                            .format(_convertString(event["DTEND"]!))
                            .toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: SizedBox(
              height: screenHeight * 0.06,
              width: screenWidth * 0.4,
              child: ElevatedButton(
                onPressed: () async {
                  addEvent(event);
                },
                child: const Text('Thêm'),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Provider(
                create: (_) => AdsBloc(),
                builder: (context, child) {
                  return const AdNative(tempType: TemplateType.small);
                }),
          )
        ],
      ),
    );
  }
}
