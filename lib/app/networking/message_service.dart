import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_app/app/models/chat.dart';
import 'package:flutter_app/app/networking/image_service.dart';
import 'package:nylo_framework/nylo_framework.dart';

import '../models/chat_status.dart';

class MessageService {
  final firebaseFirestore = FirebaseFirestore.instance;

  CollectionReference<Chat> _messagesCollection(String messagesId) =>
      firebaseFirestore
          .collection('all-messages')
          .doc(messagesId)
          .collection("messages")
          .withConverter<Chat>(
            fromFirestore: (snapshot, options) =>
                Chat.fromJson(snapshot.data()),
            toFirestore: (value, options) => value.toJson(),
          );

  Stream<DocumentSnapshot<ChatStatus>> messageInfo(String id) {
    return _messageinfoDocument(id).snapshots();
  }

  DocumentReference<ChatStatus> _messageinfoDocument(String id) {
    return firebaseFirestore
        .collection('message_info')
        .doc(id)
        .withConverter<ChatStatus>(
          fromFirestore: (snapshot, options) =>
              ChatStatus.fromMap(snapshot.data()),
          toFirestore: (value, options) => value.toMap(),
        );
  }

  Stream<QuerySnapshot<Chat>> messages(String messagesId) =>
      _messagesCollection(messagesId)
          .orderBy('createdAt', descending: true)
          .snapshots();

  Future<ChatMedia> uploadImage(
    ImageServiceModel image,
  ) async {
    final Reference storageRef =
        FirebaseStorage.instance.ref().child("chat_images");
    // final storageRef = await _messagesCollection(messagesId).doc(id).get();

    final taskSnapshot = await storageRef.putFile(
      image.file,
      SettableMetadata(
        contentType: 'image/jpg',
        cacheControl: 'max-age=604800, must-revalidate',
      ),
    );

    String url = await taskSnapshot.ref.getDownloadURL();

    return ChatMedia(url: url, fileName: image.name, type: MediaType.image);
  }

  Future messageImage({
    required String messagesId,
    required String idInfo,
    required ImageServiceModel image,
  }) async {
    ChatMedia chatMedia = await uploadImage(image);
    // FirebaseFirestore.instance.collection('messages').add(message.toJson());
    await messageAdd(messagesId, Chat.image([chatMedia]), idInfo);
    // return ;
  }

  Future messageAdd(String messagesId, Chat chat, String idInfo) async {
    await _messagesCollection(messagesId).add(chat);
    var snapshot = await (_messageinfoDocument(idInfo).get());

    var lastReadCount = 0;

    if (snapshot.exists) {
      lastReadCount = lastReadCount + (snapshot.data()?.lastReadCount ?? 0);
    }

    dump(idInfo);
    dump(lastReadCount);
    await _messageinfoDocument(idInfo).set(
      ChatStatus(
        chatDate: chat.createdAtTimestamp,
        chatKontent: chat.text,
        lastReadCount: lastReadCount + 1,
      ),
    );
  }

  Future messageText({
    required String messagesId,
    required String idInfo,
    required String message,
  }) async {
    await messageAdd(messagesId, Chat.text(message), idInfo);
  }
}
