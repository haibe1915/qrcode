import 'package:async/async.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qrcode/Sqlite/database_helper.dart';
import 'package:qrcode/model/history_model.dart';
import 'package:qrcode/qr/view/pages/convert/view/convert_page.dart';
import 'package:qrcode/qr/view/pages/qr_code/view/qr_page.dart';
import 'package:qrcode/qr/view/pages/history/view/history_page.dart';
import 'package:permission_handler/permission_handler.dart';

class StaticVariable {
  static List<HistoryItem> createdHistoryList = <HistoryItem>[];
  static List<HistoryItem> scannedHistoryList = <HistoryItem>[];
  static List<Widget> pages = [HistoryPage(), QrPage(), ConvertPage()];
  static List<String> historyPagesTabs = ['Đã quét', 'Đã tạo'];
  static StreamController<HistoryItem> createdController =
      StreamController<HistoryItem>.broadcast();
  static StreamController<HistoryItem> scannedController =
      StreamController<HistoryItem>.broadcast();
  static StreamController<String> streamSearchController =
      StreamController<String>.broadcast();
  Map<Permission, PermissionStatus> permissionStatus =
      Map<Permission, PermissionStatus>();
  static late DatabaseHelper conn;
  static String wifiSecurity = "WPA";
}
