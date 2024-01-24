class HistoryItem {
  final String type;
  final DateTime datetime;
  final String content;
  HistoryItem(
      {required this.type, required this.datetime, required this.content});

  Map<String, dynamic> toMap() {
    return {
      'Type': type,
      'Datetime': datetime.toString(),
      'Content': content,
    };
  }

  factory HistoryItem.fromMap(Map<String, dynamic> map) {
    return HistoryItem(
        type: map['Type'],
        datetime: DateTime.parse(map['Datetime']),
        content: map['Content']);
  }
}
