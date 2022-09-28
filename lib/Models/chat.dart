import 'dart:convert';

class Chat {
  final String myUid;
  final String myName;
  final String otherUid;
  final String otherName;
  final String chatId;

  Chat(
      {required this.myUid,
      required this.myName,
      required this.otherUid,
      required this.otherName,
      required this.chatId});

  Map<String, dynamic> toMap() {
    return {
      'myUid': myUid,
      'myName': myName,
      'otherUid': otherUid,
      'otherName': otherName,
      'chatId': chatId,
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
        myUid: map['myUid'] ?? '',
        myName: map['myName'] ?? '',
        otherUid: map['otherUid'] ?? '',
        otherName: map['otherName'] ?? '',
        chatId: map['chatId'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory Chat.fromJson(String source) => Chat.fromMap(json.decode(source));
}
