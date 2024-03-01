import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:qrcode/data/Sqlite/database_helper.dart';
import 'package:qrcode/model/history_model.dart';
import 'package:qrcode/ui/pages/convert/view/convert_page.dart';
import 'package:qrcode/ui/pages/qr_code/view/qr_page.dart';
import 'package:qrcode/ui/pages/history/view/history_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrcode/ui/pages/setting/view/SettingPage.dart';
import 'package:qrcode/ui/widget/AdBanner.dart';
import 'package:qrcode/ui/widget/AdInterstitial.dart';
import 'package:qrcode/ui/widget/AdNative.dart';
import 'package:qrcode/utils/shared_preference/SharedPreference.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StaticVariable {
  static List<HistoryItem> createdHistoryList = <HistoryItem>[];
  static List<HistoryItem> scannedHistoryList = <HistoryItem>[];
  static List<Widget> pages = [
    const HistoryPage(),
    const QrPage(),
    ConvertPage(),
    const SettingPage(),
  ];
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
  static final Map<String, Icon> iconCategory2 = {
    "văn bản": const Icon(
      Icons.edit_document,
      color: Colors.white,
    ),
    "wifi": const Icon(
      Icons.wifi,
      color: Colors.white,
    ),
    "url": const Icon(
      Icons.link,
      color: Colors.white,
    ),
    "điện thoại": const Icon(
      Icons.phone,
      color: Colors.white,
    ),
    "liên hệ": const Icon(
      Icons.person,
      color: Colors.white,
    ),
    "tin nhắn": const Icon(
      Icons.sms,
      color: Colors.white,
    ),
    "sự kiện": const Icon(
      Icons.calendar_month,
      color: Colors.white,
    ),
    "email": const Icon(
      Icons.email,
      color: Colors.white,
    ),
  };

  static final Map<String, Color> colorCategory = {
    "văn bản": Colors.yellow.shade700,
    "wifi": Colors.lightBlue.shade700,
    "url": Colors.blue.shade700,
    "điện thoại": Colors.green.shade700,
    "liên hệ": Colors.redAccent.shade700,
    "tin nhắn": Colors.greenAccent.shade700,
    "sự kiện": Colors.red.shade700,
    "email": Colors.pink.shade700,
  };

  static const adBannerId = "ca-app-pub-3940256099942544/6300978111";
  static const adNativeId = "ca-app-pub-3940256099942544/2247696110";
  static const adInterstitialId = "ca-app-pub-3940256099942544/1033173712";
  static AdBanner adBanner = const AdBanner();
  static NativeAd defaultAdNative = NativeAd(
      adUnitId: adNativeId,
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) {
          debugPrint('NativeAdListener onAdLoaded ${ad.toString()}.');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          debugPrint('NativeAdListener onAdFailedToLoad: $error');
          ad.dispose();
        },
      ),
      nativeTemplateStyle: NativeTemplateStyle(
          // Required: Choose a template.
          templateType: TemplateType.small,
          // Optional: Customize the ad's style.
          mainBackgroundColor: Colors.white,
          cornerRadius: 10.0,
          callToActionTextStyle: NativeTemplateTextStyle(
              textColor: Colors.white,
              backgroundColor: Colors.blue,
              style: NativeTemplateFontStyle.monospace,
              size: 16.0),
          primaryTextStyle: NativeTemplateTextStyle(
              textColor: Colors.black,
              //backgroundColor: Colors.cyan,
              style: NativeTemplateFontStyle.italic,
              size: 16.0),
          secondaryTextStyle: NativeTemplateTextStyle(
              textColor: Colors.green,
              backgroundColor: Colors.black,
              style: NativeTemplateFontStyle.bold,
              size: 16.0),
          tertiaryTextStyle: NativeTemplateTextStyle(
              textColor: Colors.brown,
              backgroundColor: Colors.amber,
              style: NativeTemplateFontStyle.normal,
              size: 16.0)));
  static DateFormat formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss');
  static late String language;
  static final interstitialAd = AdInterstitial();
}
