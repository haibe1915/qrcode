import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_contacts/properties/phone.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qrcode/blocs/Ad/ad_bloc.dart';
import 'package:qrcode/model/history_model.dart';
import 'package:qrcode/ui/pages/convert/convert_function/TextToQR.dart';
import 'package:qrcode/ui/widget/AdNative.dart';
import 'package:qrcode/ui/widget/titleBar.dart';

class QrContactPage extends StatefulWidget {
  QrContactPage({super.key, required this.historyItem, this.controller});

  final HistoryItem historyItem;
  QRViewController? controller;

  @override
  State<QrContactPage> createState() => _QrContactPageState();
}

class _QrContactPageState extends State<QrContactPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  addContact(Map<String, String> contact) async {
    final newContact = Contact()
      ..name.first = contact["FN"]!
      ..phones = [Phone(contact["TEL"]!)]
      ..addresses = [Address(contact["ADR"]!)]
      ..notes = [Note(contact["NOTE"]!)];
    await newContact.insert().then((_) {
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

  Map<String, String> extractcontactStringValues(String contactString) {
    print(contactString);
    contactString = contactString.trim();

    List<String> lines = contactString.split('\n');

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
    Map<String, String> contact =
        extractcontactStringValues(widget.historyItem.content);

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
        title: const Text('Liên hệ'),
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
          Expanded(
            child: Column(
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
                              'Họ tên:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(top: 5),
                            child: Text(
                              contact["FN"]!,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(top: 15),
                            child: const Text(
                              'Số điện thoại:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(top: 5),
                            child: Text(
                              contact["TEL"]!,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(top: 15),
                            child: const Text(
                              'Địa chỉ:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(top: 5),
                            child: Text(
                              contact["ADR"] == null ? "" : contact["ADR"]!,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(top: 15),
                            child: const Text(
                              'Ghi chú:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(top: 5),
                            child: Text(
                              contact["NOTE"] == null ? "" : contact["NOTE"]!,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                //const SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    height: screenHeight * 0.06,
                    width: screenWidth * 0.4,
                    child: ElevatedButton(
                      onPressed: () async {
                        addContact(contact);
                      },
                      child: const Text('Thêm'),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          Center(
            child: Provider(
                create: (_) => AdsBloc(),
                builder: (context, child) {
                  return const AdNative();
                }),
          ),
        ],
      ),
    );
  }
}
