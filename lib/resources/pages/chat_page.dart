// import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/chat.dart';
import 'package:flutter_app/app/models/pemesanan.dart';
import 'package:flutter_app/app/models/user.dart';
import 'package:flutter_app/app/networking/image_service.dart';
import 'package:flutter_app/app/networking/message_service.dart';
import 'package:flutter_app/app/networking/pemesanan_api_service.dart';
import 'package:flutter_app/resources/pages/image_view_page.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

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
        var docs = snapshot.data!.docs;
        var messages = docs.map((chat) => chat.data()).toList();
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
            onLongPressMessage: (message) async {
              dump(message.user == user, tag: 'onLongPressMessage');

              final chat = message as Chat;
              await showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(25.0),
                  ),
                ),
                builder: (BuildContext context) {
                  return BottomSheetWidget(
                    chat: chat,
                    id: chat.id,
                    messagesId: messagesId,
                    idInfo: idInfo,
                  );
                },
              );
            },
            onPressMessage: (message) async {
              dump(message.user == user, tag: 'onPressMessage');

              final chat = message as Chat;
              if (chat.medias?.first.url == null) {
                return;
              }
              routeTo(ImageViewPage.path, queryParameters: {
                'imageUrl': chat.medias?.first.url,
                'name': chat.medias?.first.fileName,
              });
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

class BottomSheetWidget extends StatelessWidget {
  final Chat chat;
  final String id;
  final String messagesId;
  final String idInfo;
  const BottomSheetWidget({
    super.key,
    required this.chat,
    required this.id,
    required this.messagesId,
    required this.idInfo,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          const Gap(24),
          Container(
            width: 80,
            height: 5.5,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const Gap(18),
          const Divider(),
          ListTile(
            onTap: () {
              final data = ClipboardData(text: chat.text);
              // Copy the text to the clipboard
              Clipboard.setData(data);
            },
            trailing: const Icon(Icons.copy_rounded),
            title: const Text("Salin"),
          ),
          const Divider(),
          ListTile(
            onTap: () async {
              await MessageService().messageDeleteText(
                chat: chat,
                id: id,
                messagesId: messagesId,
                idInfo: idInfo,
              );
              Navigator.pop(context);
            },
            trailing: const Icon(Icons.delete_outline_outlined),
            title: const Text("Hapus"),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
