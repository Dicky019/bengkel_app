import 'package:cloud_firestore/cloud_firestore.dart';

class ChatStatus {
  final String chatKontent;
  final int lastReadCount;
  final Timestamp chatDate;

  ChatStatus({
    required this.chatKontent,
    required this.lastReadCount,
    required this.chatDate,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chatKontent': chatKontent,
      'lastReadCount': lastReadCount,
      'chatDate': chatDate,
    };
  }

  factory ChatStatus.fromMap(Map<String, dynamic>? map) {
    return ChatStatus(
      chatKontent: map?['chatKontent'] ?? "-",
      lastReadCount: map?['lastReadCount'] ?? 0,
      chatDate: Timestamp.fromDate(
        DateTime.tryParse((map?['chatDate'] ?? "").toString()) ??
            Timestamp.now().toDate(),
      ),
    );
  }

  factory ChatStatus.skeleton() {
    return ChatStatus(
      chatKontent: "map?['chatKontent']",
      lastReadCount: 10,
      chatDate: Timestamp.now(),
    );
  }
}
