// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: overridden_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/foundation.dart';
import 'package:nylo_framework/nylo_framework.dart';

import 'user.dart';

class Chat extends ChatMessage {
  final String id;
  Chat({
    required this.id,
    required this.user,
    required this.createdAtTimestamp,
    this.isMarkdown = false,
    this.text = '',
    this.medias,
    this.status = MessageStatus.none,
  }) : super(
          user: user,
          createdAt: createdAtTimestamp.toDate().toLocal(),
        );

  /// Create a Chat instance from json data
  factory Chat.firebase(DocumentSnapshot<Map<String, dynamic>> firebaseData) {
    final User user = Auth.user<User>()!;
    return Chat(
      id: firebaseData.id,
      user: ChatUser(
        id: user.id,
        firstName: user.firstName,
        lastName: user.lastName,
        profileImage: user.imageUrl,
      ),
      createdAtTimestamp: Timestamp.fromDate(
        DateTime.tryParse(
                (firebaseData.data()?['createdAt'] ?? "").toString()) ??
            Timestamp.now().toDate(),
      ),
      text: firebaseData.data()?['text']?.toString() ?? '',
      isMarkdown: firebaseData.data()?['isMarkdown']?.toString() == 'true',
      medias: firebaseData.data()?['medias'] != null
          ? (firebaseData.data()?['medias'] as List<dynamic>)
              .map((dynamic media) =>
                  ChatMedia.fromJson(media as Map<String, dynamic>))
              .toList()
          : <ChatMedia>[],
      status: MessageStatus.parse(
          firebaseData.data()?['status'].toString() ?? 'failed'),
    );
  }

  factory Chat.image(List<ChatMedia>? medias) {
    final User user = Auth.user<User>()!;
    return Chat(
      user: ChatUser(
        id: user.id,
        firstName: user.firstName,
        lastName: user.lastName,
        profileImage: user.imageUrl,
      ),
      createdAtTimestamp: Timestamp.now(),
      medias: medias,
      id: '',
    );
  }

  factory Chat.text(String text) {
    final User user = Auth.user<User>()!;
    return Chat(
      id: '',
      user: ChatUser(
        id: user.id,
        firstName: user.firstName,
        lastName: user.lastName,
        profileImage: user.imageUrl,
      ),
      text: text,
      createdAtTimestamp: Timestamp.now(),
    );
  }

  factory Chat.user() {
    final User user = Auth.user<User>()!;
    return Chat(
      id: '',
      user: ChatUser(
        id: user.id,
        firstName: user.firstName,
        lastName: user.lastName,
        profileImage: user.imageUrl,
      ),
      createdAtTimestamp: Timestamp.now(),
    );
  }

  /// If the message is Markdown formatted then it will be converted to Markdown (by default it will be false)
  @override
  final bool isMarkdown;

  /// Text of the message (optional because you can also just send a media)
  @override
  final String text;

  /// Author of the message
  @override
  final ChatUser user;

  /// List of medias of the message
  @override
  final List<ChatMedia>? medias;

  /// Date of the message
  final Timestamp createdAtTimestamp;

  /// Status of the message TODO:
  @override
  final MessageStatus? status;

  /// Convert a Chat into a json
  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'user': user.toJson(),
      'createdAt': createdAtTimestamp.millisecondsSinceEpoch,
      'text': text,
      'medias': medias?.map((ChatMedia media) => media.toJson()).toList(),
      'status': status.toString(),
      'isMarkdown': isMarkdown,
    };
  }

  @override
  bool operator ==(covariant Chat other) {
    if (identical(this, other)) return true;

    return other.isMarkdown == isMarkdown &&
        other.text == text &&
        other.user == user &&
        listEquals(other.medias, medias) &&
        other.createdAt == createdAt &&
        other.status == status;
  }

  @override
  int get hashCode {
    return isMarkdown.hashCode ^
        text.hashCode ^
        user.hashCode ^
        medias.hashCode ^
        createdAt.hashCode ^
        status.hashCode;
  }
}
