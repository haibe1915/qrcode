package com.example.qrcode

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // TODO: Register the ListTileNativeAdFactory
        GoogleMobileAdsPlugin.registerNativeAdFactory(
                flutterEngine, "listTile", ListTileNativeAdFactory(context))
    }
}
