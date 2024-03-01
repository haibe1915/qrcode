import 'package:flutter/material.dart';
import 'package:qrcode/constant/static_variables.dart';
import 'package:qrcode/ui/pages/convert/view/ContactToQrPage.dart';
import 'package:qrcode/ui/pages/convert/view/EmailToQrPage.dart';
import 'package:qrcode/ui/pages/convert/view/EventToQrPage.dart';
import 'package:qrcode/ui/pages/convert/view/PhoneToQrPage.dart';
import 'package:qrcode/ui/pages/convert/view/SmsToQrPage.dart';
import 'package:qrcode/ui/pages/convert/view/UrlToQrPage.dart';
import 'package:qrcode/ui/pages/convert/view/WifiToQrPage.dart';
import 'TextToQrPage.dart';

class ConvertPage extends StatelessWidget {
  ConvertPage({Key? key}) : super(key: key);
  final double offset = 0;
  final List<String> name = [
    'Văn bản',
    'Wifi',
    'Url',
    'Điện thoại',
    'Liên hệ',
    // 'Vị trí',
    'Tin nhắn',
    'Sự kiện',
    'Email'
  ];

  final List<Widget> functionPages = [
    const TextToQrPage(),
    const WifiToQrPage(),
    UrlToQrPage(),
    const PhoneToQrPage(),
    const ContactToQrPage(),
    const SmsToQrPage(),
    const EventToQrPage(),
    const EmailToQrPage()
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Qr Code Generator'),
        ),
        body: Center(
          child: Container(
            margin: const EdgeInsets.only(top: 10),
            width: MediaQuery.of(context).size.width * 0.9,
            child: ListView.builder(
              itemCount: name.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(top: 5, bottom: 5),
                  height: 80,
                  child: Card(
                    elevation: 4,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => functionPages[index]),
                        );
                      },
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: StaticVariable
                                    .colorCategory[name[index].toLowerCase()],
                                borderRadius: BorderRadius.circular(5)),
                            width: 65,
                            child: Center(
                                child: StaticVariable
                                    .iconCategory2[name[index].toLowerCase()]),
                          ),
                          Expanded(
                            child: ListTile(
                              title: Text(name[index]),
                            ),
                          ),
                          const SizedBox(
                            width: 65,
                            child: Center(
                              child: Icon(
                                Icons.add_circle_rounded,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
