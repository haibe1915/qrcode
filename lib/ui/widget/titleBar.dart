import 'package:flutter/material.dart';
import 'package:qrcode/constant/static_variables.dart';
import 'package:qrcode/ui/pages/result/QrEvent.dart';

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
      margin: EdgeInsets.only(top: 20),
      child: Card(
        elevation: 4,
        child: Row(
          children: [
            Expanded(
              child: ListTile(
                leading: StaticVariable.iconCategory[widget.historyItem.type],
                title: Text(
                  widget.historyItem.datetime.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}