import 'package:country_flags/country_flags.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:qrcode/blocs/Ad/ad_bloc.dart';
import 'package:qrcode/constant/static_variables.dart';
import 'package:qrcode/ui/widget/AdNative.dart';
import 'package:qrcode/utils/Ads/firebase.dart';
import 'package:qrcode/utils/shared_preference/SharedPreference.dart';

class LanguageOption extends StatefulWidget {
  const LanguageOption({super.key, required this.onLanguageChanged});
  final Function() onLanguageChanged;
  State<LanguageOption> createState() => _LanguageOptionState();
}

class _LanguageOptionState extends State<LanguageOption> {
  String? currentLanguage = StaticVariable.language;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: InkWell(
          child: Icon(Icons.language,
              color: Theme.of(context).primaryColor, size: 40),
          onTap: () {
            logEvent(
                name: 'change_language_click', parameters: {'placement': ''});
            showModalBottomSheet(
              context: context,
              builder: (context) {
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
                return Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListView.builder(
                          itemCount: _languages.length,
                          itemBuilder: (BuildContext context, int index) {
                            final String language = _languages[index];
                            return Column(
                              children: [
                                ListTile(
                                  leading: CountryFlag.fromCountryCode(
                                    StaticVariable.countryMap[language]!,
                                    height: 30,
                                    width: 30,
                                  ),
                                  title: Text(language,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  onTap: () {
                                    StaticVariable.language = language;
                                    SharedPreference.setLanguagePreference(
                                        language);
                                    setState(() {
                                      currentLanguage = language;
                                      context.setLocale(StaticVariable
                                          .languageMap[language]!);
                                    });
                                    widget.onLanguageChanged();
                                    Navigator.pop(context);
                                  },
                                  trailing: language == StaticVariable.language
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.green,
                                        )
                                      : null,
                                ),
                                Center(
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    // Center(
                    //   child: Provider(
                    //       create: (_) => AdsBloc(),
                    //       builder: (context, child) {
                    //         return AdNative(
                    //           tempType: TemplateType.small,
                    //           width: 0.95 * MediaQuery.of(context).size.width,
                    //         );
                    //       }),
                    // )
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
