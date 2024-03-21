import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qrcode/blocs/search/search_bloc.dart';
import 'package:qrcode/blocs/search/search_event.dart';
import 'package:qrcode/constant/static_variables.dart';
import 'package:qrcode/model/history_model.dart';
import 'package:qrcode/ui/pages/result/QrContact.dart';
import 'package:qrcode/ui/pages/result/QrEmail.dart';
import 'package:qrcode/ui/pages/result/QrEvent.dart';
import 'package:qrcode/ui/pages/result/QrPhone.dart';
import 'package:qrcode/ui/pages/result/QrSms.dart';
import 'package:qrcode/ui/pages/result/QrText.dart';
import 'package:qrcode/ui/pages/result/QrUrl.dart';
import 'package:qrcode/ui/pages/result/QrWifi.dart';
import 'package:qrcode/utils/Ads/firebase.dart';

class HistoryCard extends StatefulWidget {
  const HistoryCard(
      {super.key,
      required this.historyItem,
      required this.type,
      required this.searchBloc});
  final HistoryItem historyItem;
  final String type;
  final SearchBloc searchBloc;
  @override
  State<HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String EventText(String content) {
    String summary = "";
    RegExp regExp = RegExp(r"SUMMARY:(.*)");

    Match? match = regExp.firstMatch(content);
    if (match != null) {
      summary = match.group(1)!.trim();
    }
    return summary;
  }

  String ContactText(String content) {
    String summary = "";
    RegExp regExp = RegExp(r"FN:(.*)");

    Match? match = regExp.firstMatch(content);
    if (match != null) {
      summary = match.group(1)!.trim();
    }
    return summary;
  }

  String SmsText(String content) {
    final phoneNumberStartIndex = content.indexOf(':') + 1;
    final phoneNumberEndIndex = content.indexOf('?');
    final phoneNumber =
        content.substring(phoneNumberStartIndex, phoneNumberEndIndex);
    return phoneNumber;
  }

  String EmailText(String content) {
    final emailAddressStartIndex = content.indexOf(':') + 1;
    final emailAddressEndIndex = content.indexOf('?');
    final emailAddress =
        content.substring(emailAddressStartIndex, emailAddressEndIndex);
    return emailAddress;
  }

  String WifiText(String content) {
    final wifiAddressStartIndex = content.indexOf('S') + 2;
    final wifiAddressEndIndex = content.indexOf(';');
    final wifiAddress =
        content.substring(wifiAddressStartIndex, wifiAddressEndIndex);
    return wifiAddress;
  }

  String HistoryItemText(HistoryItem item) {
    String summary = "";
    switch (item.type) {
      case 'event':
        summary = EventText(item.content);
        break;
      case 'contact':
        summary = ContactText(item.content);
        break;
      case 'sms':
        summary = SmsText(item.content);
        break;
      case 'email':
        summary = EmailText(item.content);
        break;
      case 'wifi':
        summary = WifiText(item.content);
        break;
      default:
        summary = item.content;
    }
    if (summary.length > 30) return "${summary.substring(0, 30)}...";
    return summary;
  }

  Widget resultPage(HistoryItem historyItem) {
    if (historyItem.type == "url") {
      return QrUrlPage(historyItem: historyItem);
    } else if (historyItem.type == "event") {
      return QrEventPage(historyItem: historyItem);
    } else if (historyItem.type == "contact") {
      return QrContactPage(historyItem: historyItem);
    } else if (historyItem.type == "phone") {
      return QrPhonePage(historyItem: historyItem);
    } else if (historyItem.type == "sms") {
      return QrSmsPage(historyItem: historyItem);
    } else if (historyItem.type == "email") {
      return QrEmailPage(historyItem: historyItem);
    } else if (historyItem.type == "wifi") {
      return QrWifiPage(historyItem: historyItem);
    } else
      return QrTextPage(historyItem: historyItem);
  }

  @override
  Widget build(BuildContext context) {
    List<HistoryItem> historyList = widget.type == "Scan"
        ? StaticVariable.scannedHistoryList
        : StaticVariable.createdHistoryList;
    return Container(
      margin: const EdgeInsets.only(top: 3, bottom: 3),
      height: 90,
      child: InkWell(
          onTap: () {
            logEvent(
                name: '${widget.type}_item_click',
                parameters: {'type': widget.historyItem.type});
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => resultPage(widget.historyItem)),
            );
          },
          child: Card(
            elevation: 1,
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color:
                          StaticVariable.colorCategory[widget.historyItem.type],
                      borderRadius: BorderRadius.circular(5)),
                  width: 52,
                  child: Center(
                      child: StaticVariable
                          .iconCategory2[widget.historyItem.type]),
                ),
                Expanded(
                    child: ListTile(
                  //leading: StaticVariable.iconCategory[widget.historyItem.type],
                  subtitle: Text(
                    StaticVariable.formattedDateTime
                        .format(widget.historyItem.datetime)
                        .toString(),
                    style:
                        const TextStyle(color: Color(0xFF618b6d), fontSize: 15),
                  ),
                  title: Text(HistoryItemText(widget.historyItem),
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 17)),
                )),
                IconButton(
                    onPressed: () {
                      logEvent(
                          name: '${widget.type}_item_delete_click',
                          parameters: {'placement': ''});
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: SizedBox(
                                width: 200, // Adjust the width as needed
                                height: 50, // Adjust the height as needed
                                child: Center(
                                  child: const Text("confirmDelete").tr(),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('yes').tr(),
                                  onPressed: () {
                                    logEvent(
                                        name:
                                            '${widget.type}_item_delete_confirm',
                                        parameters: {'placement': ''});
                                    if (widget.type == "Scan") {
                                      StaticVariable.conn.deleteScaned(
                                          widget.historyItem.datetime);
                                    } else if (widget.type == "Create") {
                                      StaticVariable.conn.deleteCreated(
                                          widget.historyItem.datetime);
                                    }
                                    widget.searchBloc.add(SearchEventDeleteData(
                                        str: "",
                                        type: 0,
                                        historyItem: widget.historyItem,
                                        historyList: historyList));
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('no').tr(),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          });
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Theme.of(context).primaryColor,
                    ))
              ],
            ),
          )),
    );
  }
}
