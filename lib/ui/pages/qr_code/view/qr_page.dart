import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qrcode/blocs/scanImage/scan_image_bloc.dart';
import 'package:qrcode/blocs/scanImage/scan_image_event.dart';
import 'package:qrcode/blocs/scanImage/scan_image_state.dart';
import 'package:qrcode/constant/static_variables.dart';
import 'package:qrcode/model/history_model.dart';
import 'package:qrcode/ui/pages/result/QrContact.dart';
import 'package:qrcode/ui/pages/result/QrEmail.dart';
import 'package:qrcode/ui/pages/result/QrEvent.dart';
import 'package:qrcode/ui/pages/result/QrPhone.dart';
import 'package:qrcode/ui/pages/result/QrSms.dart';
import 'package:qrcode/ui/pages/result/QrText.dart';
import 'package:qrcode/ui/pages/result/QrUrl.dart';
import 'package:qrcode/ui/pages/result/QrWifi.dart';
import 'package:qrcode/utils/Ads/firebase.dart';
import 'package:qrcode/utils/shared_preference/SharedPreference.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

class QrPage extends StatefulWidget {
  const QrPage({super.key});

  @override
  State<QrPage> createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? barcode;
  final ScanImageBloc _scanImageBloc = ScanImageBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  String typeSort(String string) {
    if (string.contains("BEGIN:VCALENDAR") &&
        string.contains("BEGIN:VEVENT") &&
        string.contains("DTSTART") &&
        string.contains("DTEND") &&
        string.contains("SUMMARY")) {
      return "event";
    } else if (string.contains("BEGIN:VCARD") &&
        string.contains("VERSION:") &&
        string.contains("FN:")) {
      return "contact";
    } else if (string.contains("WIFI:")) {
      return "wifi";
    } else if (string.contains("https://") || string.contains("http://")) {
      return "url";
    } else if (RegExp(r'^[0-9]+$').hasMatch(string) && string.length < 15) {
      return "phone";
    } else if (string.contains('sms:')) {
      return "sms";
    } else
      return "text";
  }

  Future<void> getResult(QRViewController controller, HistoryItem tmp) async {
    if (!StaticVariable.premiumState) {
      StaticVariable.rewardedAd.loadRewardedAd();
    }
    Future.delayed(Duration.zero, () {
      controller.pauseCamera();
      switch (tmp.type) {
        case "event":
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  QrEventPage(historyItem: tmp, controller: controller),
            ),
          );
          break;
        case "contact":
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  QrContactPage(historyItem: tmp, controller: controller),
            ),
          );
          break;
        case "wifi":
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  QrWifiPage(historyItem: tmp, controller: controller),
            ),
          );
          break;
        case "url":
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QrUrlPage(
                historyItem: tmp,
                controller: controller,
              ),
            ),
          );
          break;
        case "phone":
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  QrPhonePage(historyItem: tmp, controller: controller),
            ),
          );
          break;
        case "sms":
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  QrSmsPage(historyItem: tmp, controller: controller),
            ),
          );
          break;
        case "email":
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  QrEmailPage(historyItem: tmp, controller: controller),
            ),
          );
          break;
        default:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  QrTextPage(historyItem: tmp, controller: controller),
            ),
          );
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            QRView(
              key: qrKey,
              onQRViewCreated: onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Theme.of(context).colorScheme.primary,
                borderWidth: 10,
                cutOutSize: MediaQuery.of(context).size.width * 0.8,
              ),
            ),
            Positioned(
                top: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white24),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                          onPressed: () {
                            _scanImageBloc.add(ScanImageScan());
                          },
                          icon: const Icon(Icons.image)),
                      IconButton(
                          onPressed: () async {
                            await controller?.toggleFlash();
                          },
                          icon: const Icon(Icons.flash_on)),
                      IconButton(
                          onPressed: () async {
                            await controller?.flipCamera();
                          },
                          icon: const Icon(Icons.switch_camera)
                          // FutureBuilder(
                          //   future: controller?.getCameraInfo(),
                          //   builder: (context, snapshot) {
                          //     if (snapshot.data != null) {
                          //       return Icon(Icons.switch_camera);
                          //     } else {
                          //       return Container();
                          //     }
                          //   },
                          // )
                          )
                    ],
                  ),
                )),
            BlocBuilder<ScanImageBloc, ScanImageState>(
                bloc: _scanImageBloc,
                builder: (context, state) {
                  if (state is ScanImageNotScan) {
                    return Container();
                  } else if (state is ScanImageScaned) {
                    logEvent(name: 'scan_image_success', parameters: {});
                    getResult(controller!, state.tmp);
                  } else if (state is ScanImageLoading) {
                    return Center(
                        child: Container(
                            width: 200,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(
                                  0.5), // Set the desired opacity value (0.0 to 1.0)
                              borderRadius: BorderRadius.circular(
                                  10), // Set the desired border radius
                            ),
                            child: const Center(
                                child: CircularProgressIndicator())));
                  } else if (state is ScanImageError) {
                    logEvent(
                        name: 'scan_qr_error',
                        parameters: {'error': state.message});
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: SizedBox(
                              width: 200,
                              height: 100,
                              child: Center(
                                  child: const Text('Can not scan, try again')
                                      .tr()),
                            ),
                            actions: [
                              TextButton(
                                child: const Text('close').tr(),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _scanImageBloc.add(ScanImageEndError());
                                },
                              ),
                            ],
                          );
                        });
                  }
                  return Container();
                })
          ],
        ),
      ),
    );
  }

  void onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      final prefs = await SharedPreferences.getInstance();
      final lastScanTime = prefs.getInt("lastScanTimePreference");
      final now = DateTime.now().millisecondsSinceEpoch;
      if ((lastScanTime != null && now - lastScanTime > 5000)) {
        setState(() {
          barcode = scanData;
        });
        if (barcode != null) {
          print(barcode!.code);
          _scanImageBloc.add(ScanImageCapture(barcode!.code!));
        }
        // if (await SharedPreference.getVibrationPreference()) {
        //   Vibration.vibrate(duration: 1000);
        // }
        prefs.setInt(
            "lastScanTimePreference", DateTime.now().millisecondsSinceEpoch);
      }
    });
  }

  @override
  void reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) controller!.resumeCamera();
  }
}
