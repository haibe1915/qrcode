import 'package:async/async.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qrcode/data/Sqlite/database_helper.dart';
import 'package:qrcode/model/history_model.dart';
import 'package:qrcode/ui/pages/convert/view/convert_page.dart';
import 'package:qrcode/ui/pages/qr_code/view/qr_page.dart';
import 'package:qrcode/ui/pages/history/view/history_page.dart';
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
  static final Map<String, Icon> iconCategory = {
    "văn bản": Icon(Icons.edit_document),
    "wifi": Icon(Icons.wifi),
    "url": Icon(Icons.link),
    "điện thoại": Icon(Icons.phone),
    "liên hệ": Icon(Icons.person),
    // 'Vị trí',
    "tin nhắn": Icon(Icons.sms),
    "sự kiện": Icon(Icons.calendar_month),
    "email": Icon(Icons.email),
  };
  static final ThemeData myTheme = ThemeData(
    primarySwatch: Colors.blueGrey,
    brightness: Brightness.light,
  );
}
