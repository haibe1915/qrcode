import 'package:scan/scan.dart';

class ScanImage {
  static Future<String?> scanImageFromImage(String imagePath) async {
    String? result = await Scan.parse(imagePath);
    if (result != null) {
      return result;
    } else {
      return "ERROR";
    }
  }
}
