import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:qrcode/blocs/Ad/ad_bloc.dart';
import 'package:qrcode/ui/homePage.dart';
import 'package:qrcode/ui/qr_app.dart';
import 'package:qrcode/ui/widget/AdNative.dart';
import 'package:qrcode/utils/shared_preference/SharedPreference.dart';
import 'package:qrcode/constant/static_variables.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});
  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String finalLanguage = 'English (US)';
  final List<String> _languages = [
    'Spanish (Mexico)',
    'Vietnamese',
    'Arabic',
    'English (US)',
    'French',
    'German',
    'Portuguese (Brazil)',
    'Spanish (Spain)',
    'Turkish',
    'Japanese',
    'Dutch',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('language'.tr()),
          actions: [
            IconButton(
                onPressed: () {
                  StaticVariable.language = finalLanguage;
                  SharedPreference.setLanguagePreference(finalLanguage);
                  context.setLocale(StaticVariable.languageMap[finalLanguage]!);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const QrApp()));
                },
                icon: const Icon(Icons.check))
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: _languages.length,
                  itemBuilder: (BuildContext context, int index) {
                    final String language = _languages[index];
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              finalLanguage = language;
                            });
                          },
                          child: ListTile(
                            leading: CountryFlag.fromCountryCode(
                              StaticVariable.countryMap[language]!,
                              height: 30,
                              width: 30,
                            ),
                            title: Text(language,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor)),
                            trailing: Radio<String>(
                              value: language,
                              groupValue: finalLanguage,
                              onChanged: (String? value) {
                                setState(() {
                                  finalLanguage = value!;
                                });
                              },
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 0.5,
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
              Center(
                child: Provider(
                    create: (_) => AdsBloc(),
                    builder: (context, child) {
                      return AdNative(
                        tempType: TemplateType.small,
                        width: MediaQuery.of(context).size.width,
                        factoryId: "adFactoryLanguage",
                        height: 230,
                      );
                    }),
              ),
            ],
          ),
        ));
  }
}

class LanguageList extends StatefulWidget {
  const LanguageList({Key? key}) : super(key: key);

  @override
  State<LanguageList> createState() => _LanguageListState();
}

class _LanguageListState extends State<LanguageList> {
  void _showLanguageDialog(BuildContext context, String language) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(language),
          content: const Text('You selected this language!'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                StaticVariable.language = language;
                SharedPreference.setLanguagePreference(language);
                context.setLocale(StaticVariable.languageMap[language]!);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const QrApp()));
              },
            ),
            TextButton(
              child: const Text('Back'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
