import 'package:flutter/material.dart';
import 'package:qrcode/constant/static_variables.dart';
import 'package:qrcode/ui/homePage.dart';
import 'package:qrcode/blocs/Ad/ad_bloc.dart';
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
            Provider<AdsBloc>(
              create: (rootContext) => AdsBloc(),
            ),
          ],
          builder: (context, child) {
            return const HomePage(title: 'QrApp');
          }),
    );
  }
}
