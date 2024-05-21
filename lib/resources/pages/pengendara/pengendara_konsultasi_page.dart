import 'package:flutter/material.dart';
import 'package:flutter_app/app/controllers/pengendara_controller.dart';
import 'package:gap/gap.dart';

import 'package:intl/intl.dart';
import 'package:nylo_framework/nylo_framework.dart';

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

  final keyLoadingPemesanan = 'keyLoadingPemesanan';
  // final keyLoadingTerdekat = 'listBengkelTerdekat';

  @override
  init() async {
    DateTime.now().toString().dump(tag: "DateTime");

    if (widget.controller.fetchListPemesanan) {
      return;
    }

    setLoading(true, name: keyLoadingPemesanan);

    final data = await Future.wait([
      widget.controller.getPemesanans(),
    ]).then((v) {
      widget.controller.fetchListPemesanan = true;
      return v;
    });

    widget.controller.listPemesanan = data[0];

    // widget.controller.listBengkelTerdekat = data[1];

    setLoading(false, name: keyLoadingPemesanan);
  }

  @override
  stateUpdated(dynamic data) async {
    // e.g. to update this state from another class
    // updateState(PengendaraKonsultasi.state, data: "example payload");
  }

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
      ),
      body: Skeletonizer(
        enabled: isLoading(name: keyLoadingPemesanan),
        containersColor: Colors.grey.shade50,
        child: ListView.separated(
          itemBuilder: (context, index) {
            final pemesanan = widget.controller.listPemesanan[index];
            return Column(
              children: [
                if (index == 0) const Gap(8),
                ListTileChat(
                  imageUrl: pemesanan.bengkel.user?.imageUrl,
                  name: pemesanan.bengkel.name,
                  chatDate: DateTime.now(),
                  chatKontent: "dasdsadadasdads",
                  onTap: () {},
                  lastReadCount: '2',
                ),
              ],
            );
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
  final String? imageUrl;
  final String name;
  final String chatKontent;
  final String lastReadCount;
  final DateTime chatDate;
  final void Function()? onTap;

  const ListTileChat({
    super.key,
    this.imageUrl,
    required this.name,
    required this.chatKontent,
    required this.chatDate,
    this.onTap,
    required this.lastReadCount,
  });

  @override
  Widget build(BuildContext context) {
    final avatar = imageUrl != null
        ? Image.network(imageUrl!)
        : Image.asset("noimage.png").localAsset();
    return ListTile(
      onTap: onTap,
      leading: avatar.circleAvatar(),
      title: Text(name),
      subtitle: Text(chatKontent),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(DateFormat.Hm().format(DateTime.now())),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade600,
              shape: BoxShape.circle,
            ),
            child: Text(
              lastReadCount,
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
