import 'package:flutter/material.dart';
import 'package:qrcode/constant/static_variables.dart';
import 'package:qrcode/ui/homePage.dart';
import 'package:qrcode/blocs/Ad/ad_bloc.dart';
import 'package:provider/provider.dart';
import 'package:qrcode/ui/languageScreen.dart';
import 'package:qrcode/utils/shared_preference/SharedPreference.dart';

class QrApp extends StatelessWidget {
  const QrApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MaterialColor createMaterialColor(Color color) {
      List<int> strengths = <int>[
        50,
        100,
        200,
        300,
        400,
        500,
        600,
        700,
        800,
        900
      ];
      Map<int, Color> swatch = {};
      final int primary = color.value;
      for (int strength in strengths) {
        final double opacity = 0.1 + (strength / 1000.0);
        final Color swatchColor =
            Color(primary & 0x00FFFFFF).withOpacity(opacity);
        swatch[strength] = swatchColor;
      }
      return MaterialColor(primary, swatch);
    }

    final ThemeData myTheme = ThemeData(
      primarySwatch: Colors.blueGrey,
      brightness: Brightness.light,
    );

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: myTheme,
        home: FutureBuilder<String>(
          future: SharedPreference.getLanguagePreference(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.data != "") {
              return const HomePage(title: 'QrApp');
            } else {
              return const LanguageScreen();
            }
          },
        ));
  }
}
