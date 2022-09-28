import 'dart:convert';

class Message {
  final String text;
  final String myUid;
  final String time;

  Message({required this.text, required this.myUid, required this.time});

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'myUid': myUid,
      'time': time,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      text: map['text'] ?? '',
      myUid: map['myUid'] ?? '',
      time: map['time'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source));
}
