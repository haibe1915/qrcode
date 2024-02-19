import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qrcode/data/Sqlite/database_helper.dart';
import 'package:qrcode/model/history_model.dart';
import 'package:qrcode/ui/pages/convert/view/convert_page.dart';
import 'package:qrcode/ui/pages/qr_code/view/qr_page.dart';
import 'package:qrcode/ui/pages/history/view/history_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrcode/ui/widget/AdBanner.dart';

class StaticVariable {
  static List<HistoryItem> createdHistoryList = <HistoryItem>[];
  static List<HistoryItem> scannedHistoryList = <HistoryItem>[];
  static List<Widget> pages = [HistoryPage(), const QrPage(), ConvertPage()];
  static List<String> historyPagesTabs = ['Đã quét', 'Đã tạo'];
  static StreamController<HistoryItem> createdController =
      StreamController<HistoryItem>.broadcast();
  static StreamController<HistoryItem> scannedController =
      StreamController<HistoryItem>.broadcast();
  static StreamController<String> streamSearchController =
      StreamController<String>.broadcast();
  Map<Permission, PermissionStatus> permissionStatus =
      <Permission, PermissionStatus>{};
  static late DatabaseHelper conn;
  static String wifiSecurity = "WPA";
  static final Map<String, Icon> iconCategory = {
    "văn bản": Icon(
      Icons.edit_document,
      color: Colors.yellow.shade700,
    ),
    "wifi": Icon(Icons.wifi, color: Colors.lightBlue.shade700),
    "url": Icon(Icons.link, color: Colors.blue.shade700),
    "điện thoại": Icon(Icons.phone, color: Colors.green.shade700),
    "liên hệ": Icon(Icons.person, color: Colors.redAccent.shade700),
    "tin nhắn": Icon(
      Icons.sms,
      color: Colors.greenAccent.shade700,
    ),
    "sự kiện": Icon(
      Icons.calendar_month,
      color: Colors.red.shade700,
    ),
    "email": Icon(
      Icons.email,
      color: Colors.pink.shade700,
    ),
  };
  static final ThemeData myTheme = ThemeData(
    primarySwatch: Colors.blueGrey,
    brightness: Brightness.light,
  );
  static const adBannerId = "ca-app-pub-3940256099942544/6300978111";
  static const adNativeId = "ca-app-pub-3940256099942544/2247696110";
  static AdBanner adBanner = const AdBanner();
}
