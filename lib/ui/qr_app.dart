import 'package:flutter/material.dart';
import 'package:qrcode/constant/static_variables.dart';
import 'package:qrcode/ui/homePage.dart';
import 'package:qrcode/blocs/AdBanner/ad_banner_bloc.dart';
import 'package:provider/provider.dart';

class QrApp extends StatelessWidget {
  const QrApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: StaticVariable.myTheme,
      home: MultiProvider(
        providers: [
          // Register the AdsBloc as a provider
          Provider<AdsBloc>(
            create: (_) => AdsBloc(),
          ),
          // Add more providers if needed
        ],
        child: const HomePage(title: 'QrApp'),
      ),
    );
  }
}
