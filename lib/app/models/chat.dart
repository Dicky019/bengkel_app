// ignore_for_file: overridden_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:nylo_framework/nylo_framework.dart';

import 'user.dart';

class Chat extends ChatMessage {
  Chat({
    required this.user,
    required this.createdAtTimestamp,
    this.isMarkdown = false,
    this.text = '',
    this.medias,
    this.status = MessageStatus.none,
  }) : super(user: user, createdAt: createdAtTimestamp.toDate().toLocal());

  /// Create a Chat instance from json data
  factory Chat.fromJson(Map<String, dynamic>? jsonData) {
    final User user = Auth.user<User>()!;
    return Chat(
      user: ChatUser(
        id: user.id,
        firstName: user.firstName,
        lastName: user.lastName,
        profileImage: user.imageUrl,
      ),
      createdAtTimestamp: Timestamp.fromDate(
        DateTime.tryParse((jsonData?['createdAt'] ?? "").toString()) ??
            Timestamp.now().toDate(),
      ),
      text: jsonData?['text']?.toString() ?? '',
      isMarkdown: jsonData?['isMarkdown']?.toString() == 'true',
      medias: jsonData?['medias'] != null
          ? (jsonData?['medias'] as List<dynamic>)
              .map((dynamic media) =>
                  ChatMedia.fromJson(media as Map<String, dynamic>))
              .toList()
          : <ChatMedia>[],
      status: MessageStatus.parse(jsonData?['status'].toString() ?? 'failed'),
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
      status: MessageStatus.parse('send'),
    );
  }

  factory Chat.text(String text) {
    final User user = Auth.user<User>()!;
    return Chat(
      user: ChatUser(
        id: user.id,
        firstName: user.firstName,
        lastName: user.lastName,
        profileImage: user.imageUrl,
      ),
      text: text,
      createdAtTimestamp: Timestamp.now(),
      status: MessageStatus.parse('send'),
    );
  }

  factory Chat.user() {
    final User user = Auth.user<User>()!;
    return Chat(
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
}
