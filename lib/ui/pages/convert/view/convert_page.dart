import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrcode/constant/static_variables.dart';
import 'package:qrcode/ui/pages/convert/view/ContactToQrPage.dart';
import 'package:qrcode/ui/pages/convert/view/EmailToQrPage.dart';
import 'package:qrcode/ui/pages/convert/view/EventToQrPage.dart';
import 'package:qrcode/ui/pages/convert/view/PhoneToQrPage.dart';
import 'package:qrcode/ui/pages/convert/view/SmsToQrPage.dart';
import 'package:qrcode/ui/pages/convert/view/UrlToQrPage.dart';
import 'package:qrcode/ui/pages/convert/view/WifiToQrPage.dart';
import 'package:qrcode/ui/widget/LanguageOption.dart';
import 'package:qrcode/ui/widget/PremiumOption.dart';
import 'TextToQrPage.dart';

class ConvertPage extends StatefulWidget {
  const ConvertPage({super.key, required this.onLanguageChange});
  final Function() onLanguageChange;
  State<ConvertPage> createState() => _ConvertPageState();
}

class _ConvertPageState extends State<ConvertPage> {
  final List<String> name = [
    'text',
    'wifi',
    'url',
    'phone',
    'contact',
    // 'Vị trí',
    'sms',
    'event',
    'email'
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

  void changeLanguage() {
    setState(() {});
    widget.onLanguageChange();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            children: [
              const PremiumOption(),
              const Expanded(child: SizedBox()),
              LanguageOption(
                onLanguageChanged: changeLanguage,
              )
            ],
          ),
        ),
        body: Center(
          child: Container(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              width: MediaQuery.of(context).size.width * 0.92,
              child: GridView.count(
                crossAxisCount: 2,
                children: List.generate(functionPages.length, (index) {
                  return Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => functionPages[index]),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: StaticVariable
                                .colorCategory[name[index].toLowerCase()],
                            borderRadius: BorderRadius.circular(5)),
                        width: MediaQuery.of(context).size.width * 0.5,
                        //height: MediaQuery.of(context).size.width * 0.7,
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: StaticVariable
                                  .iconCategory3[name[index].toLowerCase()],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              name[index],
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                            ).tr()
                          ],
                        )),
                      ),
                    ),
                  );
                }),
              )),
        ),
      ),
    );
  }
}
