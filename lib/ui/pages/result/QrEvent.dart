import 'package:easy_localization/easy_localization.dart';
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
import 'package:share_plus/share_plus.dart';

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
    if (!StaticVariable.premiumState) {
      StaticVariable.interstitialAd
          .populateInterstitialAd(adUnitId: StaticVariable.adInterstitialId);
      StaticVariable.interstitialAd.loadInterstitialAd();
    }
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
                content: SizedBox(
                  width: 200, // Adjust the width as needed
                  height: 100, // Adjust the height as needed
                  child: Center(child: const Text('addSuccess').tr()),
                ),
                actions: [
                  TextButton(
                    child: const Text('close').tr(),
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
    QRCodeWidget qrCodeWidget = QRCodeWidget(data: widget.historyItem.content);

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
        title: const Text('event').tr(),
        // actions: [
        //   IconButton(
        //     padding:
        //         const EdgeInsets.only(left: 10, top: 20, bottom: 20, right: 10),
        //     alignment: Alignment.bottomLeft,
        //     icon: const Icon(
        //       Icons.qr_code,
        //       size: 24,
        //       color: Colors.white,
        //     ),
        //     onPressed: () {
        //       showDialog(
        //           context: context,
        //           builder: (BuildContext context) {
        //             QRCodeWidget qrCodeWidget =
        //                 QRCodeWidget(data: widget.historyItem.content);
        //             return AlertDialog(
        //               content: SizedBox(
        //                 width: 200, // Adjust the width as needed
        //                 height: 200, // Adjust the height as needed
        //                 child: qrCodeWidget,
        //               ),
        //               actions: [
        //                 TextButton(
        //                   child: const Text('Save'),
        //                   onPressed: () async {
        //                     qrCodeWidget.saveImageToGallery();
        //                   },
        //                 ),
        //                 TextButton(
        //                   child: const Text('Close'),
        //                   onPressed: () {
        //                     Navigator.of(context).pop();
        //                   },
        //                 )
        //               ],
        //             );
        //           });
        //     },
        //   )
        // ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TitleBar(screenWidth: screenWidth, widget: widget),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: qrCodeWidget,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: screenWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                            onPressed: () {
                              qrCodeWidget.saveImageToGallery();
                            },
                            icon: const Icon(Icons.save),
                            label: const Text('save').tr()),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton.icon(
                            onPressed: () {
                              Share.share('${'summmary'.tr()}${': ${event["SUMMARY"]}\n'
                                  'description'.tr()}${': ${event["DESCRIPTION"] ?? ""}\n'
                                  'location'.tr()}${': ${event["LOCATION"] ?? ""}\n'
                                  'start time'.tr()}${': ${event["DTSTART"]}\n'
                                  'end time'.tr()}: ${event["DTEND"]}\n');
                            },
                            icon: const Icon(Icons.share),
                            label: const Text('share').tr()),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton.icon(
                            onPressed: () async {
                              addEvent(event);
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('add').tr()),
                      ],
                    ),
                  ),
                  Center(
                    child: Provider(
                        create: (_) => AdsBloc(),
                        builder: (context, child) {
                          return AdNative(
                            tempType: TemplateType.small,
                            width: 0.8 * MediaQuery.of(context).size.width,
                          );
                        }),
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    margin: const EdgeInsets.only(top: 10),
                    child: Card(
                      elevation: 6,
                      clipBehavior: Clip.hardEdge,
                      child: Container(
                        width: screenWidth * 0.8,
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${'summary'.tr()}:',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              child: Text(
                                event["SUMMARY"]!,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${'description'.tr()}:',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              child: Text(
                                event["DESCRIPTION"]!,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${'location'.tr()}:',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              child: Text(
                                event["LOCATION"]!,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${'start time'.tr()}:',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
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
                            Text(
                              '${'end time'.tr()}:',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
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
                  // Center(
                  //   child: SizedBox(
                  //     height: screenHeight * 0.06,
                  //     width: screenWidth * 0.4,
                  //     child: ElevatedButton(
                  //       onPressed: () async {
                  //         addEvent(event);
                  //       },
                  //       child: const Text('Thêm'),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Provider<AdsBloc>(
            create: (rootContext) => AdsBloc(),
            child: Material(
              child: SizedBox(
                height: 50,
                child: StaticVariable.adBanner,
              ),
            ),
          )
        ],
      ),
    );
  }
}
