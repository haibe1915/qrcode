import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      fontFamily: GoogleFonts.rubik().fontFamily,
      primarySwatch: const MaterialColor(
        0xFF006d3d,
        <int, Color>{
          50: Color(0xFFe0f2e9),
          100: Color(0xFFb3e0c5),
          200: Color(0xFF80cba0),
          300: Color(0xFF4db77c),
          400: Color(0xFF26a566),
          500: Color(0xFF006d3d),
          600: Color(0xFF006437),
          700: Color(0xFF005b31),
          800: Color(0xFF00522a),
          900: Color(0xFF003e1e),
        },
      ),
      brightness: Brightness.light,
    );

    return MaterialApp(
        color: Colors.black,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        theme: myTheme,
        darkTheme: ThemeData(
          primarySwatch: const MaterialColor(
            0xFF006d3d,
            <int, Color>{
              50: Color(0xFFe0f2e9),
              100: Color(0xFFb3e0c5),
              200: Color(0xFF80cba0),
              300: Color(0xFF4db77c),
              400: Color(0xFF26a566),
              500: Color(0xFF006d3d),
              600: Color(0xFF006437),
              700: Color(0xFF005b31),
              800: Color(0xFF00522a),
              900: Color(0xFF003e1e),
            },
          ),
          brightness: Brightness.dark,
        ),
        home: Provider<AdsBloc>(
          create: (rootContext) => AdsBloc(),
          child: StaticVariable.language == ''
              ? const LanguageScreen()
              : const HomePage(title: "qrcode"),
        ));
  }
}
