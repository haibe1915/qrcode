import 'package:flutter_contacts/contact.dart';
import 'package:qrcode/model/history_model.dart';

class Search {
  List<HistoryItem> searchHistoryItem(
      String string, List<HistoryItem> historyList) {
    List<HistoryItem> result = [];
    if (string.isNotEmpty) {
      for (var element in historyList) {
        if (element.content.toLowerCase().contains(string.toLowerCase())) {
          result.add(element);
        }
      }
    } else {
      result = List.from(historyList);
    }
    return result;
  }

  List<Contact> searchContact(String string, List<Contact> contactList) {
    List<Contact> result = [];
    if (string.isNotEmpty) {
      for (var element in contactList) {
        if (element.displayName.toLowerCase().contains(string.toLowerCase())) {
          result.add(element);
        }
      }
    } else {
      result = List.from(contactList);
    }
    return result;
  }
}
