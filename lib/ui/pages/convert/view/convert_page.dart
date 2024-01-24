import 'package:flutter/material.dart';
import 'package:qrcode/ui/pages/convert/view/ContactToQrPage.dart';
import 'package:qrcode/ui/pages/convert/view/EventToQrPage.dart';
import 'package:qrcode/ui/pages/convert/view/PhoneToQrPage.dart';
import 'package:qrcode/ui/pages/convert/view/UrlToQrPage.dart';
import 'package:permission_handler/permission_handler.dart';
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
    // 'Tin nhắn',
    'Sự kiện',
    // 'Email'
  ];

  final List<Widget> functionPages = [
    TextToQrPage(),
    WifiToQrPage(),
    UrlToQrPage(),
    PhoneToQrPage(),
    ContactToQrPage(),
    EventToQrPage(),
  ];
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    ScrollController scrollController =
        ScrollController(initialScrollOffset: offset);
    return Scaffold(
        appBar: AppBar(
          title: Text('QrCode'),
        ),
        body: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                for (int i = 0; i < name.length; i++)
                  InkWell(
                    child: Container(
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
