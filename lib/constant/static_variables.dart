import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:qrcode/data/Sqlite/database_helper.dart';
import 'package:qrcode/model/history_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrcode/ui/widget/AdBanner.dart';
import 'package:qrcode/ui/widget/AdInterstitial.dart';
import 'package:qrcode/ui/widget/AdRewarded.dart';

class StaticVariable {
  static DateFormat formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss');

  static List<HistoryItem> createdHistoryList = <HistoryItem>[];
  static List<HistoryItem> scannedHistoryList = <HistoryItem>[];
  static StreamController<HistoryItem> createdController =
      StreamController<HistoryItem>.broadcast();
  static StreamController<HistoryItem> scannedController =
      StreamController<HistoryItem>.broadcast();
  static StreamController<String> streamSearchController =
      StreamController<String>.broadcast();
  Map<Permission, PermissionStatus> permissionStatus =
      <Permission, PermissionStatus>{};
  static late DatabaseHelper conn;

  //Icon color
  static const mainColor = MaterialColor(
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
  );
  static final Map<String, Icon> iconCategory = {
    "text": const Icon(
      Icons.edit_document,
      color: Color(0xFFE6C33C),
      size: 50,
    ),
    "wifi": const Icon(Icons.wifi, color: Color(0xFF3C91E6)),
    "url": const Icon(Icons.link, color: Color(0xFF3C7AE6)),
    "phone": const Icon(Icons.phone, color: Color(0xFF3CE67B)),
    "contact": const Icon(Icons.person, color: Color(0xFFE63C58)),
    "sms": const Icon(
      Icons.sms,
      color: Color(0xFF3C4AE6),
    ),
    "event": const Icon(
      Icons.calendar_month,
      color: Color(0xFFE69E3C),
    ),
    "email": const Icon(
      Icons.email,
      color: Color(0xFFE63CB1),
    ),
  };
  static final Map<String, Icon> iconCategory2 = {
    "text": const Icon(
      Icons.edit_document,
      color: Colors.white,
    ),
    "wifi": const Icon(Icons.wifi, color: Colors.white),
    "url": const Icon(Icons.link, color: Colors.white),
    "phone": const Icon(Icons.phone, color: Colors.white),
    "contact": const Icon(Icons.person, color: Colors.white),
    "sms": const Icon(Icons.sms, color: Colors.white),
    "event": const Icon(Icons.calendar_month, color: Colors.white),
    "email": const Icon(Icons.email, color: Colors.white),
  };
  static final Map<String, Icon> iconCategory3 = {
    "text": const Icon(
      Icons.edit_document,
      color: Colors.white,
      size: 50,
    ),
    "wifi": const Icon(Icons.wifi, color: Colors.white, size: 50),
    "url": const Icon(Icons.link, color: Colors.white, size: 50),
    "phone": const Icon(Icons.phone, color: Colors.white, size: 50),
    "contact": const Icon(Icons.person, color: Colors.white, size: 50),
    "sms": const Icon(Icons.sms, color: Colors.white, size: 50),
    "event": const Icon(Icons.calendar_month, color: Colors.white, size: 50),
    "email": const Icon(Icons.email, color: Colors.white, size: 50),
  };

  static final Map<String, Color> colorCategory = {
    "text": const Color(0xFFE6C33C),
    "wifi": const Color(0xFF3C91E6),
    "url": const Color(0xFF3C7AE6),
    "phone": const Color(0xFF3CE67B),
    "contact": const Color(0xFFE63C58),
    "sms": const Color(0xFF3C4AE6),
    "event": const Color(0xFFE69E3C),
    "email": const Color(0xFFE63CB1),
  };

  // Ad relate
  static const adBannerId = "ca-app-pub-3940256099942544/6300978111";
  static const adNativeId = "ca-app-pub-3940256099942544/2247696110";
  static const adInterstitialId = "ca-app-pub-3940256099942544/1033173712";
  static const adRewarded = "ca-app-pub-3940256099942544/5224354917";
  static final interstitialAd = AdInterstitial();
  static final rewardedAd = AdRewarded();
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

  //Language
  static late String language;
  static final Map<String, Locale> languageMap = {
    'Spanish (Mexico)': const Locale('es', 'MX'),
    'Arabic': const Locale('ar'),
    'English (US)': const Locale('en', 'US'),
    'French': const Locale('fr'),
    'German': const Locale('de'),
    'Portuguese (Brazil)': const Locale('pt', 'BR'),
    'Spanish (Spain)': const Locale('es', 'ES'),
    'Turkish': const Locale('tr'),
    'Japanese': const Locale('ja'),
    'Dutch': const Locale('nl'),
    'Vietnamese': const Locale('vi', 'VN')
  };

  static final Map<String, String> countryMap = {
    'Spanish (Mexico)': 'MX',
    'Arabic': 'SA',
    'English (US)': 'US',
    'French': 'FR',
    'German': 'DE',
    'Portuguese (Brazil)': 'PT',
    'Spanish (Spain)': 'ES',
    'Turkish': 'TR',
    'Japanese': 'JP',
    'Dutch': 'NL',
    'Vietnamese': 'VN'
  };

  static late bool premiumState;
}
