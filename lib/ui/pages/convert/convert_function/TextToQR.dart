import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeWidget extends StatelessWidget {
  final String data;

  QRCodeWidget({required this.data});
  final GlobalKey qrImageViewKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        RepaintBoundary(
            key: qrImageViewKey,
            child: QrImageView(data: data, version: QrVersions.auto, size: 200))
      ],
    ));
  }

  Future<void> saveImageToGallery() async {
    try {
      RenderRepaintBoundary boundary = qrImageViewKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage(pixelRatio: 3.0);
      final whitePaint = Paint()..color = Colors.white;
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder,
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()));
      canvas.drawRect(
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
          whitePaint);
      canvas.drawImage(image, Offset.zero, Paint());
      final picture = recorder.endRecording();
      final img = await picture.toImage(image.width, image.height);

      ByteData? byteData = await img.toByteData(format: ImageByteFormat.png);

      Uint8List imageData = byteData!.buffer.asUint8List();
      final result = await ImageGallerySaver.saveImage(imageData);
      if (result['isSuccess']) {
        showDialog(
            context: qrImageViewKey.currentContext!,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Container(
                  width: 200, // Adjust the width as needed
                  height: 100, // Adjust the height as needed
                  child: Center(child: Text('Thêm thành công')),
                ),
                actions: [
                  TextButton(
                    child: Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      } else {
        showDialog(
            context: qrImageViewKey.currentContext!,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Container(
                  width: 200, // Adjust the width as needed
                  height: 100, // Adjust the height as needed
                  child: Center(child: Text('Thêm thất bại')),
                ),
                actions: [
                  TextButton(
                    child: Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      }
    } catch (e) {
      // Error occurred while saving image
      print('Error saving image to gallery: $e');
    }
  }
}
