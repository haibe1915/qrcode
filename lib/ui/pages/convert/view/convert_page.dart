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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const PremiumOption(),
              const SizedBox(width: 10),
              LanguageOption(
                onLanguageChanged: changeLanguage,
              )
            ],
          ),
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.only(top: 15),
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
                              title: Text(name[index]).tr(),
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
