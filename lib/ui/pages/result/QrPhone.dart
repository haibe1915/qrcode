import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qrcode/blocs/Ad/ad_bloc.dart';
import 'package:qrcode/model/history_model.dart';
import 'package:qrcode/ui/widget/QRCodeWidget.dart';
import 'package:qrcode/ui/widget/AdNative.dart';
import 'package:qrcode/ui/widget/titleBar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class QrPhonePage extends StatefulWidget {
  QrPhonePage({super.key, required this.historyItem, this.controller});

  final HistoryItem historyItem;
  QRViewController? controller;

  @override
  State<QrPhonePage> createState() => _QrPhonePageState();
}

class _QrPhonePageState extends State<QrPhonePage> {
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
    final QRCodeWidget qrCodeWidget =
        QRCodeWidget(data: widget.historyItem.content);

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
        title: const Text('phone number').tr(),
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
      body: SingleChildScrollView(
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
              width: screenWidth * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                      onPressed: () {
                        qrCodeWidget.saveImageToGallery();
                      },
                      icon: const Icon(Icons.save),
                      label: const Text('save').tr()),
                  ElevatedButton.icon(
                      onPressed: () {
                        Share.share(
                            '${'phone number'.tr()}: ${widget.historyItem.content}');
                      },
                      icon: const Icon(Icons.share),
                      label: const Text('share').tr()),
                  ElevatedButton.icon(
                      onPressed: () async {
                        launchUrl(
                            Uri.parse("tel:${widget.historyItem.content}"));
                      },
                      icon: const Icon(Icons.call),
                      label: const Text('call').tr()),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Card(
                elevation: 4,
                clipBehavior: Clip.hardEdge,
                child: SizedBox(
                  height: screenHeight * 0.1,
                  width: screenWidth * 0.8,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        widget.historyItem.content,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
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
            //         launchUrl(Uri.parse("tel:${widget.historyItem.content}"));
            //       },
            //       child: const Text('Gọi'),
            //     ),
            //   ),
            // ),
            const SizedBox(height: 20),
            Center(
              child: Provider(
                  create: (_) => AdsBloc(),
                  builder: (context, child) {
                    return AdNative(
                      tempType: TemplateType.small,
                      width: 0.8 * MediaQuery.of(context).size.width,
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
