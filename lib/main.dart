import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrcode/data/Sqlite/database_helper.dart';
import 'package:qrcode/constant/static_variables.dart';
import 'package:qrcode/model/history_model.dart';
import 'package:qrcode/blocs/qr_observer.dart';
import 'package:qrcode/ui/qr_app.dart';
import 'package:qrcode/utils/shared_preference/SharedPreference.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive,
      overlays: [SystemUiOverlay.top]);
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  StaticVariable.conn = DatabaseHelper();
  StaticVariable.language = await SharedPreference.getLanguagePreference();
  await StaticVariable.conn.initializeDatabase();
  BlocObserver observer = const QrObserver();

  StaticVariable.createdController.stream.listen(
    (HistoryItem item) {
      debugPrint('Created item added: $item');
      StaticVariable.createdHistoryList.add(item);
    },
    onError: (dynamic error) {
      debugPrint('Failed to add created item: $error');
    },
    onDone: () {
      debugPrint('Stream closed');
    },
  );
  StaticVariable.scannedController.stream.listen(
    (HistoryItem item) {
      debugPrint('Scanned item added: $item');
      StaticVariable.scannedHistoryList.add(item);
    },
    onError: (dynamic error) {
      debugPrint('Failed to add scanned item: $error');
    },
    onDone: () {
      debugPrint('Stream closed');
    },
  );
  StaticVariable.createdController.addStream(StaticVariable.conn.readCreated());
  StaticVariable.scannedController.addStream(StaticVariable.conn.readScanned());
  await Future.delayed(const Duration(seconds: 0));
  MobileAds.instance.initialize();

  runApp(EasyLocalization(
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('vi', 'VN'),
        const Locale('es', 'MX'),
        const Locale('ar'),
        const Locale('en', 'US'),
        const Locale('fr'),
        const Locale('de'),
        const Locale('pt', 'BR'),
        const Locale('es', 'ES'),
        const Locale('tr'),
        const Locale('ja'),
        const Locale('nl'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      child: Builder(builder: ((context) {
        context.setLocale(StaticVariable.languageMap[StaticVariable.language]!);
        return const QrApp();
      }))));
}
