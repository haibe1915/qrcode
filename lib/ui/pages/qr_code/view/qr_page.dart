import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qrcode/constant/static_variables.dart';
import 'package:qrcode/model/history_model.dart';

class QrPage extends StatefulWidget {
  const QrPage({super.key});

  @override
  State<QrPage> createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? barcode;

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
      return "sự kiện";
    } else if (string.contains("BEGIN:VCARD") &&
        string.contains("VERSION:") &&
        string.contains("FN:")) {
      return "liên hệ";
    } else if (string.contains("WIFI:") &&
        string.contains("S:") &&
        string.contains("P:")) {
      return "wifi";
    } else if (string.contains("https://") || string.contains("http://")) {
      return "url";
    } else if (RegExp(r'^[0-9]+$').hasMatch(string) && string.length < 15) {
      return "điện thoại";
    } else
      return "văn bản";
  }

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
              borderWidth: 10,
              cutOutSize: MediaQuery.of(context).size.width * 0.8,
            ),
          ),
          Positioned(
              top: 10,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white24),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                        onPressed: () async {
                          await controller?.toggleFlash();
                        },
                        icon: FutureBuilder<bool?>(
                          future: controller?.getFlashStatus(),
                          builder: (context, snapshot) {
                            if (snapshot.data != null) {
                              return Icon(snapshot.data!
                                  ? Icons.flash_on
                                  : Icons.flash_off);
                            } else {
                              return Container();
                            }
                          },
                        )),
                    IconButton(
                        onPressed: () async {
                          await controller?.flipCamera();
                        },
                        icon: Icon(Icons.switch_camera)
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
              ))
        ],
      ),
    ));
  }

  void onQRViewCreated(QRViewController controller) {
    print("check");
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        barcode = scanData;
      });
      print("scanned");
      if (barcode != null) {
        print(barcode!.code);
        HistoryItem tmp = HistoryItem(
          type: typeSort(barcode!.code!),
          datetime: DateTime.now(),
          content: barcode!.code!,
        );
        StaticVariable.scannedController.add(tmp);
        StaticVariable.conn.insertScanned(tmp);
      }
    });
    print("end");
  }

  @override
  void reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) controller!.resumeCamera();
  }
}
