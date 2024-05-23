// import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/chat.dart';
import 'package:flutter_app/app/models/pemesanan.dart';
import 'package:flutter_app/app/models/user.dart';
import 'package:flutter_app/app/networking/image_service.dart';
import 'package:flutter_app/app/networking/message_service.dart';
import 'package:flutter_app/app/networking/pemesanan_api_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatPage extends NyStatefulWidget {
  static const path = '/chat-map';

  ChatPage({super.key}) : super(path, child: _ChatPageState());
}

class _ChatPageState extends NyState<ChatPage> {
  late final String messagesId;
  late final String noTelephone;
  late final String name;
  late final String idInfo;
  late final String? imageUrl;
  final imageService = ImageService();
  final messageService = MessageService();
  // @override
  // init() async {
  //   dump(queryParameters(), tag: "queryParameters");
  // }

  /// Use boot if you need to load data before the [view] is rendered.
  @override
  boot() async {
    dump(queryParameters(), tag: "queryParameters");
    final query = queryParameters();

    final User? user = Auth.user<User>();

    if (query['id'] == null) {
      return await pop(result: {"status": "Query Parameters NOT FOUND"});
    }

    final Pemesanan? getPemesanan =
        await PemesananApiService(buildContext: widget.controller.context!)
            .getPemesanan(query['id']);

    if (getPemesanan == null) {
      return await pop(result: {"status": "Pemesanan NOT FOUND"});
    }

    if (user == null) {
      return await pop(result: {"status": "User NOT FOUND"});
    }

    final pengendara = getPemesanan.pengendara;
    final bengkel = getPemesanan.bengkel;
    final isMontir = user.role == Role.motir;

    messagesId = getPemesanan.messagesId;
    idInfo = isMontir ? bengkel.id : pengendara.id;
    dump(idInfo);
    noTelephone = isMontir ? pengendara.noTelephone : bengkel.noTelephone;
    name = isMontir
        ? "${pengendara.user!.firstName} ${pengendara.user!.lastName}"
        : bengkel.name;
    imageUrl = isMontir ? pengendara.user?.imageUrl : bengkel.user?.imageUrl;
  }

  @override
  Widget view(BuildContext context) {
    final image = imageUrl != null
        ? Image.network(imageUrl!)
        : Image.asset("noimage.png").localAsset();
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 1,
        title: Row(
          children: [
            image.circleAvatar(radius: 22),
            const Gap(16),
            Text(
              name,
            ),
          ],
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () => launchUrl(Uri(scheme: 'tel', path: noTelephone)),
            icon: const Icon(Icons.call_outlined),
          )
        ],
      ),
      body: ChatView(
        imageService: imageService,
        messageService: messageService,
        messagesId: messagesId,
        idInfo: idInfo,
        user: Chat.user().user,
      ),
    );
  }
}

class ChatView extends StatelessWidget {
  final ImageService imageService;
  final MessageService messageService;
  final ChatUser user;
  final String messagesId;
  final String idInfo;

  const ChatView({
    super.key,
    required this.imageService,
    required this.messageService,
    required this.user,
    required this.messagesId,
    required this.idInfo,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: messageService.messages(messagesId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
          );
        }
        var messages = snapshot.data!.docs.map((chat) => chat.data()).toList();
        return DashChat(
          inputOptions: InputOptions(
            autocorrect: true,
            sendOnEnter: true,
            trailing: [
              IconButton.filled(
                icon: const Icon(
                  Icons.camera_alt_rounded,
                  size: 24,
                ),
                onPressed: () => messageImage(ImageSource.camera),
              ),
              IconButton.filled(
                icon: const Icon(
                  Icons.photo,
                  size: 24,
                ),
                onPressed: () => messageImage(ImageSource.gallery),
              ),
            ],
          ),
          messageOptions: MessageOptions(
            showOtherUsersAvatar: false,
            onLongPressMessage: (message) {
              dump(message.user == user, tag: 'onLongPressMessage');
            },
            onPressMessage: (message) {
              dump(message.user == user, tag: 'onPressMessage');
            },
          ),
          currentUser: user,
          onSend: (ChatMessage message) async {
            await messageService.messageText(
              messagesId: messagesId,
              idInfo: idInfo,
              message: message.text,
            );
          },
          messages: messages,
        );
      },
    );
  }

  void messageImage(ImageSource source) async {
    EasyLoading.show();
    final pickImage = await imageService.pickImageFile(
      source: source,
      imageQuality: 70,
    );
    if (pickImage == null) {
      return;
    }
    await messageService.messageImage(
      messagesId: messagesId,
      idInfo: idInfo,
      image: pickImage,
    );
    EasyLoading.dismiss();
  }
}
