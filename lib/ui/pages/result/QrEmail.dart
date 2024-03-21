import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qrcode/blocs/Ad/ad_bloc.dart';
import 'package:qrcode/constant/static_variables.dart';
import 'package:qrcode/model/history_model.dart';
import 'package:qrcode/ui/widget/QRCodeWidget.dart';
import 'package:qrcode/ui/widget/AdNative.dart';
import 'package:qrcode/ui/widget/titleBar.dart';
import 'package:qrcode/utils/Ads/firebase.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class QrEmailPage extends StatefulWidget {
  QrEmailPage({super.key, required this.historyItem, this.controller});

  final HistoryItem historyItem;
  QRViewController? controller;

  @override
  State<QrEmailPage> createState() => _QrEmailPageState();
}

class _QrEmailPageState extends State<QrEmailPage> {
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

  Map<String, String> extractEmailStringValues(String emailString) {
    final emailAddressStartIndex = emailString.indexOf(':') + 1;
    final emailAddressEndIndex = emailString.indexOf('?');
    final emailAddress =
        emailString.substring(emailAddressStartIndex, emailAddressEndIndex);

    final subjectStartIndex = emailString.indexOf('subject=') + 8;
    final subjectEndIndex = emailString.indexOf('&', subjectStartIndex);
    final subject = Uri.decodeQueryComponent(
        emailString.substring(subjectStartIndex, subjectEndIndex));

    final bodyStartIndex = emailString.indexOf('body=') + 5;
    final body =
        Uri.decodeQueryComponent(emailString.substring(bodyStartIndex));

    Map<String, String> values = {};
    values["email"] = emailAddress;
    values["subject"] = subject;
    values["body"] = body;

    return values;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Map<String, String> contact =
        extractEmailStringValues(widget.historyItem.content);
    QRCodeWidget qrCodeWidget = QRCodeWidget(data: widget.historyItem.content);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Change the back button icon
          onPressed: () {
            if (widget.controller != null) {
              widget.controller!.resumeCamera();
            }
            Navigator.of(context).pop();
          },
        ),
        title: const Text('email').tr(),
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
                              logEvent(name: 'qr_save', parameters: {
                                'type': widget.historyItem.type
                              });
                              qrCodeWidget.saveImageToGallery();
                            },
                            icon: const Icon(Icons.save),
                            label: const Text('save').tr()),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton.icon(
                            onPressed: () {
                              logEvent(name: 'content_share', parameters: {
                                'type': widget.historyItem.type
                              });
                              Share.share('${'email'.tr()}${': ${contact["email"]}\n'
                                  'subject'.tr()}${': ${contact["subject"] ?? ""}\n'
                                  'message'.tr()}: ${contact["body"] ?? ""}\n');
                            },
                            icon: const Icon(Icons.share),
                            label: const Text('share').tr()),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton.icon(
                            onPressed: () async {
                              launchUrl(Uri.parse(widget.historyItem.content));
                            },
                            icon: const Icon(Icons.send),
                            label: const Text('send').tr()),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
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
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      'Email:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      contact["email"]!,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      'Chủ đề:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      contact["subject"]!,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      'Nội dung:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      contact["body"]!,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  )
                                ],
                              )))),
                  // Center(
                  //   child: Center(
                  //     child: Container(
                  //         height: screenHeight * 0.1,
                  //         width: screenWidth * 0.4,
                  //         padding: const EdgeInsets.only(top: 10),
                  //         child: Card(
                  //             elevation: 4,
                  //             child: InkWell(
                  //                 onTap: () async {
                  //                   launchUrl(Uri.parse(widget.historyItem.content));
                  //                 },
                  //                 child: const Center(child: Text('Gửi'))))),
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
