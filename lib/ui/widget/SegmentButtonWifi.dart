import 'package:flutter/material.dart';

class SegmentButtonWifi extends StatefulWidget {
  const SegmentButtonWifi({required Key key, required this.onResultChanged})
      : super(key: key);
  final void Function(String) onResultChanged;

  @override
  State<SegmentButtonWifi> createState() => _SegmentButtonWifiState();
}

class _SegmentButtonWifiState extends State<SegmentButtonWifi> {
  String result = "WPA";
  @override
  Widget build(BuildContext context) {
    return SegmentedButton<String>(
      segments: const <ButtonSegment<String>>[
        ButtonSegment<String>(
            value: "WPA",
            label: Text('WPA/WPA2'),
            icon: Icon(Icons.calendar_view_day)),
        ButtonSegment<String>(
            value: "WEP",
            label: Text('WEP'),
            icon: Icon(Icons.calendar_view_week)),
      ],
      selected: <String>{result},
      onSelectionChanged: (Set<String> newSelection) {
        setState(() {
          result = newSelection.first;
        });
        widget.onResultChanged.call(result);
      },
    );
  }

  String wifiSecurityResult() {
    return result;
  }
}
