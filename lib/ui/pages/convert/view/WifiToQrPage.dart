
import 'package:flutter/material.dart';
import 'package:qrcode/constant/static_variables.dart';
import 'package:qrcode/model/history_model.dart';
import 'package:qrcode/ui/pages/result/QrWifi.dart';

class WifiToQrPage extends StatefulWidget {
  const WifiToQrPage({super.key});

  @override
  State<WifiToQrPage> createState() => _WifiToQrPageState();
}

class _WifiToQrPageState extends State<WifiToQrPage> {
  final TextEditingController _ssidEditingController = TextEditingController();
  final TextEditingController _passwordEditingController = TextEditingController();
  String result = "WPA";

  @override
  void dispose() {
    _ssidEditingController.dispose();
    _passwordEditingController.dispose();
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
          title: const Text('Văn bản'),
          actions: [
            IconButton(
              padding: const EdgeInsets.only(
                  left: 10, top: 20, bottom: 20, right: 10),
              alignment: Alignment.bottomLeft,
              icon: const Icon(
                Icons.check,
                size: 24,
                color: Colors.white,
              ),
              onPressed: () {
                var data =
                    "WIFI:S:${_ssidEditingController.text};T:$result;P:${_passwordEditingController.text};;";
                HistoryItem tmp = HistoryItem(
                    type: 'wifi', datetime: DateTime.now(), content: data);
                StaticVariable.createdController.add(tmp);
                StaticVariable.conn.insertCreated(tmp);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QrWifiPage(
                            historyItem: tmp,
                          )),
                );
              },
            )
          ],
        ),
        body: Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.only(top: 20),
            child: Card(
                elevation: 4,
                clipBehavior: Clip.hardEdge,
                child: SizedBox(
                    height: screenHeight * 0.4,
                    width: screenWidth * 0.8,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          margin:
                              const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                          child: TextField(
                            controller: _ssidEditingController,
                            decoration: const InputDecoration(
                              hintText: 'SSID',
                              contentPadding: EdgeInsets.all(10),
                              border: InputBorder.none,
                            ),
                            maxLines: null,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          margin:
                              const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                          child: TextField(
                            controller: _passwordEditingController,
                            decoration: const InputDecoration(
                              hintText: 'Mật khẩu',
                              contentPadding: EdgeInsets.all(10),
                              border: InputBorder.none,
                            ),
                            maxLines: null,
                          ),
                        ),
                        SegmentedButton<String>(
                          segments: const <ButtonSegment<String>>[
                            ButtonSegment<String>(
                                value: "WPA",
                                label: Text('WPA/WPA2'),
                                icon: Icon(Icons.calendar_view_day)),
                            ButtonSegment<String>(
                                value: "WEP",
                                label: Text('WEP'),
                                icon: Icon(Icons.calendar_view_week)),
                          ],
                          selected: <String>{result},
                          onSelectionChanged: (Set<String> newSelection) {
                            setState(() {
                              result = newSelection.first;
                            });
                          },
                        )
                      ],
                    )))));
  }
}
