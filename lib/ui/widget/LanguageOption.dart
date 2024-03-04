import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qrcode/constant/static_variables.dart';
import 'package:qrcode/utils/shared_preference/SharedPreference.dart';

class LanguageOption extends StatefulWidget {
  const LanguageOption({super.key, required this.onLanguageChanged});
  final Function() onLanguageChanged;
  State<LanguageOption> createState() => _LanguageOptionState();
}

class _LanguageOptionState extends State<LanguageOption> {
  String currentLanguage = StaticVariable.language;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.flag),
      title: const Text("language").tr(),
      trailing: Text(currentLanguage),
      onTap: () {
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
            return Container(
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
                        title: Text(language,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        onTap: () {
                          StaticVariable.language = language;
                          SharedPreference.setLanguagePreference(language);
                          setState(() {
                            currentLanguage = language;
                            context.setLocale(
                                StaticVariable.languageMap[language]!);
                          });
                          widget.onLanguageChanged();
                          Navigator.pop(context);
                        },
                      ),
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.75,
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
            );
          },
        );
      },
    );
  }
}
