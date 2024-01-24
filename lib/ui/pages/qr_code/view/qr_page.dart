import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qrcode/constant/static_variables.dart';
import 'package:qrcode/model/history_model.dart';
import 'package:qrcode/repositories/image_gallery/getImage.dart';
import 'package:qrcode/ui/pages/result/QrContact.dart';
import 'package:qrcode/ui/pages/result/QrEvent.dart';
import 'package:qrcode/ui/pages/result/QrPhone.dart';
import 'package:qrcode/ui/pages/result/QrText.dart';
import 'package:qrcode/ui/pages/result/QrUrl.dart';

class QrPage extends StatefulWidget {
  const QrPage({super.key});

  @override
  State<QrPage> createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? barcode;
  XFile? _image;

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

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
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
                        onPressed: () {
                          setState(() {
                            pickImage();
                          });
                        },
                        icon: Icon(Icons.image)),
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
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        barcode = scanData;
      });
      String type = typeSort(barcode!.code!);
      if (barcode != null) {
        print(barcode!.code);
        HistoryItem tmp = HistoryItem(
          type: type,
          datetime: DateTime.now(),
          content: barcode!.code!,
        );
        StaticVariable.scannedController.add(tmp);
        StaticVariable.conn.insertScanned(tmp);
        controller.pauseCamera();
        switch (type) {
          case "sự kiện":
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QrEventPage(historyItem: tmp),
              ),
            );
            break;
          case "liên hệ":
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QrContactPage(historyItem: tmp),
              ),
            );
            break;
          case "wifi":
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    QrTextPage(historyItem: tmp, controller: controller),
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
          case "điện thoại":
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    QrPhonePage(historyItem: tmp, controller: controller),
              ),
            );
            break;
          case "văn bản":
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    QrTextPage(historyItem: tmp, controller: controller),
              ),
            );
        }
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
