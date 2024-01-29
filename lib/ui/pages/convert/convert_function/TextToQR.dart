import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeWidget extends StatelessWidget {
  final String data;

  QRCodeWidget({super.key, required this.data});
  final GlobalKey qrImageViewKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Center(
        key: qrImageViewKey,
        child: QrImageView(data: data, version: QrVersions.auto, size: 200));
  }

  Future<void> saveImageToGallery() async {
    try {
      RenderRepaintBoundary boundary = qrImageViewKey.currentContext!
          .findRenderObject()! as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List imageData = byteData!.buffer.asUint8List();
      final result = await ImageGallerySaver.saveImage(imageData);
      if (result['isSuccess']) {
        // Image saved successfully
        print('Image saved to gallery');
      } else {
        // Failed to save image
        print('Failed to save image to gallery');
      }
    } catch (e) {
      // Error occurred while saving image
      print('Error saving image to gallery: $e');
    }
  }
}
