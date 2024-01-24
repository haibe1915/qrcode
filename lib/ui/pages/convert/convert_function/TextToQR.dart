import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeWidget extends StatelessWidget {
  final String data;

  QRCodeWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: QrImageView(data: data, version: QrVersions.auto, size: 200));
  }
}
