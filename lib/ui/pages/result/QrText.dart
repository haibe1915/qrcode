import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qrcode/blocs/Ad/ad_bloc.dart';
import 'package:qrcode/constant/static_variables.dart';
import 'package:qrcode/model/history_model.dart';
import 'package:qrcode/ui/pages/convert/convert_function/TextToQR.dart';
import 'package:qrcode/ui/widget/AdNative.dart';
import 'package:qrcode/ui/widget/titleBar.dart';

class QrTextPage extends StatefulWidget {
  QrTextPage({super.key, required this.historyItem, this.controller});

  final HistoryItem historyItem;
  QRViewController? controller;

  @override
  State<QrTextPage> createState() => _QrTextPageState();
}

class _QrTextPageState extends State<QrTextPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back), // Change the back button icon
            onPressed: () {
              if (widget.controller != null) {
                print("resume");
                widget.controller!.resumeCamera();
              }
              Navigator.of(context).pop();
            },
          ),
          title: const Text('Văn bản'),
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
                    child: SizedBox(
                        height: screenHeight * 0.4,
                        width: screenWidth * 0.8,
                        child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                            margin: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 10),
                            child: Text(widget.historyItem.content))))),
            const SizedBox(height: 20),
            Center(
              child: Provider(
                  create: (_) => AdsBloc(),
                  builder: (context, child) {
                    return const AdNative();
                  }),
            )
          ],
        ));
  }
}
