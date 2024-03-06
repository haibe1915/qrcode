import 'package:qrcode/constant/static_variables.dart';
import 'package:qrcode/model/history_model.dart';

class AddImageToDb {
  static addImage(String content) {
    String type = typeSort(content);
    HistoryItem tmp = HistoryItem(
      type: type,
      datetime: DateTime.now(),
      content: content,
    );
    StaticVariable.scannedController.add(tmp);
    StaticVariable.conn.insertScanned(tmp);
    return tmp;
  }

  static String typeSort(String string) {
    if (string.contains("BEGIN:VCALENDAR") &&
        string.contains("BEGIN:VEVENT") &&
        string.contains("DTSTART") &&
        string.contains("DTEND") &&
        string.contains("SUMMARY")) {
      return "event";
    } else if (string.contains("BEGIN:VCARD") &&
        string.contains("VERSION:") &&
        string.contains("FN:")) {
      return "contact";
    } else if (string.contains("WIFI:")) {
      return "wifi";
    } else if (string.contains("https://") || string.contains("http://")) {
      return "url";
    } else if (RegExp(r'^[0-9]+$').hasMatch(string) && string.length < 15) {
      return "phone";
    } else if (string.contains('sms:')) {
      return "sms";
    } else
      return "text";
  }
}
