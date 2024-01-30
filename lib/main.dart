import 'dart:io';

import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrcode/data/Sqlite/database_helper.dart';
import 'package:qrcode/constant/static_variables.dart';
import 'package:qrcode/model/history_model.dart';
import 'package:qrcode/blocs/qr_observer.dart';
import 'package:qrcode/ui/qr_app.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  StaticVariable.conn = DatabaseHelper();
  await StaticVariable.conn.initializeDatabase();
  BlocObserver observer = const QrObserver();
  StaticVariable.createdController.stream.listen(
    (HistoryItem item) {
      print('Created item added: $item');
      StaticVariable.createdHistoryList.add(item);
    },
    onError: (dynamic error) {
      print('Failed to add created item: $error');
    },
    onDone: () {
      print('Stream closed');
    },
  );
  StaticVariable.scannedController.stream.listen(
    (HistoryItem item) {
      print('Scanned item added: $item');
      StaticVariable.scannedHistoryList.add(item);
    },
    onError: (dynamic error) {
      print('Failed to add scanned item: $error');
    },
    onDone: () {
      print('Stream closed');
    },
  );
  StaticVariable.createdController.addStream(StaticVariable.conn.readCreated());
  StaticVariable.scannedController.addStream(StaticVariable.conn.readScanned());
  await Future.delayed(const Duration(seconds: 1));

  runApp(QrApp());
}
