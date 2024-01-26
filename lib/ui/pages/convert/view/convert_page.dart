import 'package:flutter/material.dart';
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
    double screenHeight = MediaQuery.of(context).size.height;
    ScrollController scrollController =
        ScrollController(initialScrollOffset: offset);
    return Scaffold(
        appBar: AppBar(
          title: const Text('QrCode'),
        ),
        body: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                for (int i = 0; i < name.length; i++)
                  InkWell(
                    child: SizedBox(
                        height: screenHeight * 0.1,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text(name[i])])),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => functionPages[i]),
                      );
                    },
                  ),
              ],
            )));
  }
}
