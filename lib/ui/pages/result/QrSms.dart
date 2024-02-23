import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qrcode/blocs/Ad/ad_bloc.dart';
import 'package:qrcode/model/history_model.dart';
import 'package:qrcode/ui/widget/QRCodeWidget.dart';
import 'package:qrcode/ui/widget/AdNative.dart';
import 'package:qrcode/ui/widget/titleBar.dart';
import 'package:url_launcher/url_launcher.dart';

class QrSmsPage extends StatefulWidget {
  QrSmsPage({super.key, required this.historyItem, this.controller});

  final HistoryItem historyItem;
  QRViewController? controller;

  @override
  State<QrSmsPage> createState() => _QrSmsPageState();
}

class _QrSmsPageState extends State<QrSmsPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Map<String, String> extractSmsStringValues(String smsString) {
    final phoneNumberStartIndex = smsString.indexOf(':') + 1;
    final phoneNumberEndIndex = smsString.indexOf('?');
    final phoneNumber =
        smsString.substring(phoneNumberStartIndex, phoneNumberEndIndex);

    final messageStartIndex = smsString.indexOf('body=') + 5;
    final message =
        Uri.decodeQueryComponent(smsString.substring(messageStartIndex));

    Map<String, String> values = {};
    values["phone_number"] = phoneNumber;
    values["message"] = message;

    return values;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Map<String, String> contact =
        extractSmsStringValues(widget.historyItem.content);

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
        title: const Text('Tin nhắn'),
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
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              'Liên hệ:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(top: 5),
                            child: Text(
                              contact["phone_number"]!,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              'Nội dung:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(top: 5),
                            child: Text(
                              contact["message"]!,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      )))),
          Center(
            child: Center(
              child: Container(
                  height: screenHeight * 0.1,
                  width: screenWidth * 0.4,
                  padding: const EdgeInsets.only(top: 10),
                  child: Card(
                      elevation: 4,
                      child: InkWell(
                          onTap: () async {
                            launchUrl(Uri.parse(widget.historyItem.content));
                          },
                          child: const Center(child: Text('Gửi'))))),
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
