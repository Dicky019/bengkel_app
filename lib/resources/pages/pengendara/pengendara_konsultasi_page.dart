import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/chat_status.dart';
import 'package:flutter_app/app/networking/message_service.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:nylo_framework/nylo_framework.dart';

import 'package:flutter_app/app/controllers/pengendara_controller.dart';

class PengendaraKonsultasi extends StatefulWidget {
  final PengendaraController controller;
  const PengendaraKonsultasi({super.key, required this.controller});

  static String state = "pengendara_konsultasi";

  @override
  createState() => _PengendaraKonsultasiState();
}

class _PengendaraKonsultasiState extends NyState<PengendaraKonsultasi> {
  _PengendaraKonsultasiState() {
    stateName = PengendaraKonsultasi.state;
  }

  @override
  init() async {
    DateTime.now().toString().dump(tag: "DateTime");

    if (widget.controller.fetchListPemesanan) {
      return;
    }

    final data = await Future.wait([
      widget.controller.getPemesanans(widget.controller.getUser.pengendara!.id),
    ]);

    widget.controller.listPemesanan = data[0];
  }

  @override
  stateUpdated(dynamic data) async {
    // e.g. to update this state from another class
    // updateState(PengendaraKonsultasi.state, data: "example payload");
  }

  final messageService = MessageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Konsultasi",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Skeletonizer(
        enabled: !widget.controller.fetchListPemesanan,
        containersColor: Colors.grey.shade50,
        child: ListView.separated(
          itemBuilder: (context, index) {
            final pemesanan = widget.controller.listPemesanan[index];
            final mainChild = ListTileChat(
              onTap: () => widget.controller.goToChat(pemesanan),
              id: pemesanan.bengkel.id,
              name: pemesanan.bengkel.name,
              imageUrl: pemesanan.bengkel.user?.imageUrl,
              messageService: messageService,
            );

            if (index == 0) {
              return Column(
                children: [if (index == 0) const Gap(8), mainChild],
              );
            }

            return mainChild;
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Gap(8);
          },
          itemCount: widget.controller.listPemesanan.length,
        ),
      ),
    );
  }
}

class ListTileChat extends StatelessWidget {
  final void Function()? onTap;
  final String id;
  final String name;
  final String? imageUrl;
  final MessageService messageService;

  const ListTileChat({
    super.key,
    this.onTap,
    required this.id,
    required this.name,
    this.imageUrl,
    required this.messageService,
  });

  @override
  Widget build(BuildContext context) {
    dump(id);
    final avatar = imageUrl != null
        ? Image.network(imageUrl!)
        : Image.asset("noimage.png").localAsset();

    return StreamBuilder(
      stream: messageService.messageInfo(id),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data?.data() != null) {
          return main(avatar, snapshot.data?.data());
        }
        return main(
          avatar,
          ChatStatus.fromMap(null),
        );
      },
    );
  }

  ListTile main(Image avatar, ChatStatus? listTileChatModel) {
    return ListTile(
      onTap: onTap,
      leading: avatar.circleAvatar(),
      title: Text(name),
      subtitle: listTileChatModel?.chatKontent != null
          ? Text(listTileChatModel!.chatKontent)
          : null,
      trailing: listTileChatModel?.lastReadCount == null &&
              listTileChatModel?.chatDate == null
          ? null
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat.Hm().format(
                    listTileChatModel!.chatDate.toDate(),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade600,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    listTileChatModel.lastReadCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
