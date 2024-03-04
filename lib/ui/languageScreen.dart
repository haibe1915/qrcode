import 'package:flutter/material.dart';
import 'package:qrcode/ui/homePage.dart';
import 'package:qrcode/ui/qr_app.dart';
import 'package:qrcode/utils/shared_preference/SharedPreference.dart';
import 'package:qrcode/constant/static_variables.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
        color: Colors.blueGrey,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text(
                  'Choose your language:',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 30),
              LanguageList(),
            ],
          ),
        ),
      ),
    );
  }
}

class LanguageList extends StatefulWidget {
  const LanguageList({Key? key}) : super(key: key);

  @override
  State<LanguageList> createState() => _LanguageListState();
}

class _LanguageListState extends State<LanguageList> {
  final List<String> _languages = [
    'Spanish (Mexico)',
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
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomePage(title: 'QrApp')));
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      height: MediaQuery.of(context).size.height * 0.7,
      width: MediaQuery.of(context).size.width * 0.8,
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
                  _showLanguageDialog(context, language);
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
  }
}
