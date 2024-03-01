import 'package:flutter/material.dart';
import 'package:qrcode/constant/static_variables.dart';

class TitleBar extends StatelessWidget {
  TitleBar({
    super.key,
    required this.screenWidth,
    this.widget,
  });

  final double screenWidth;
  var widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth * 0.8,
      margin: const EdgeInsets.only(top: 20),
      child: Card(
        elevation: 4,
        child: Row(
          children: [
            Container(
              height: 50,
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: StaticVariable.colorCategory[widget.historyItem.type],
                  borderRadius: BorderRadius.circular(5)),
              width: 50,
              child: Center(
                  child: StaticVariable.iconCategory2[widget.historyItem.type]),
            ),
            Expanded(
              child: ListTile(
                title: Text(
                  StaticVariable.formattedDateTime
                      .format(widget.historyItem.datetime)
                      .toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
