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

class QrWifiPage extends StatefulWidget {
  QrWifiPage({super.key, required this.historyItem, this.controller});

  final HistoryItem historyItem;
  QRViewController? controller;

  @override
  State<QrWifiPage> createState() => _QrWifiPageState();
}

class _QrWifiPageState extends State<QrWifiPage> {
  bool _obscureText = true;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Map<String, String> extractWifiData(String wifiData) {
    RegExp regExpS = RegExp(r"S:([^;]+)");
    String? valueS = regExpS.firstMatch(wifiData)?.group(1);

    RegExp regExpT = RegExp(r"T:([^;]+)");
    String? valueT = regExpT.firstMatch(wifiData)?.group(1);

    RegExp regExpP = RegExp(r"P:([^;]+)");
    String? valueP = regExpP.firstMatch(wifiData)?.group(1);

    Map<String, String> values = {};
    values["wifi"] = valueS!;
    values["password"] = valueP!;
    values["type"] = valueT!;
    return values;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    Map<String, String> wifi = extractWifiData(widget.historyItem.content);
    QRCodeWidget qrCodeWidget = QRCodeWidget(data: widget.historyItem.content);
    TextEditingController passwordController =
        TextEditingController(text: wifi["password"]);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (widget.controller != null) {
              widget.controller!.resumeCamera();
            }
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Wifi'),
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
              width: screenWidth * 0.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                      onPressed: () {
                        qrCodeWidget.saveImageToGallery();
                      },
                      icon: const Icon(Icons.save),
                      label: const Text('Lưu')),
                  ElevatedButton.icon(
                      onPressed: () {
                        Share.share('Wifi: ${wifi["wifi"]}\n'
                            'Security type: ${wifi["type"]}');
                      },
                      icon: const Icon(Icons.share),
                      label: const Text('Chia sẻ')),
                ],
              ),
            ),
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
                          'Wifi:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(top: 5),
                        child: Text(
                          wifi["wifi"]!,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(top: 15),
                        child: const Text(
                          'Password:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(top: 5),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  enabled: false,
                                  controller: passwordController,
                                  obscureText: _obscureText,
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTapDown: (_) {
                                  setState(() {
                                    _obscureText = false;
                                  });
                                },
                                onTapUp: (_) {
                                  setState(() {
                                    _obscureText = true;
                                  });
                                },
                                child: const Icon(Icons.remove_red_eye),
                              )
                            ],
                          )),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(top: 15),
                        child: const Text(
                          'Security type:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(top: 5),
                        child: Text(
                          wifi["type"]!,
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
