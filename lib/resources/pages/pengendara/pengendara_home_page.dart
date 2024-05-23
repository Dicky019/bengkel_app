import 'package:flutter/material.dart';
import 'package:flutter_app/app/controllers/pengendara_controller.dart';
import 'package:flutter_app/app/models/bengkel.dart';
import 'package:flutter_app/bootstrap/extensions.dart';
import 'package:gap/gap.dart';
import 'package:nylo_framework/nylo_framework.dart';

class PengendaraHome extends StatefulWidget {
  final PengendaraController controller;
  const PengendaraHome({super.key, required this.controller});

  static String state = "pengendara_home";

  @override
  createState() => _PengendaraHomeState();
}

class _PengendaraHomeState extends NyState<PengendaraHome> {
  _PengendaraHomeState() {
    stateName = PengendaraHome.state;
  }

  @override
  init() async {
    if (!widget.controller.fetchListBengkelPopular) {
      widget.controller.listBengkelPopular =
          await widget.controller.getPopulerBengkels();
    }

    if (!widget.controller.fetchListBengkelTerdekat) {
      widget.controller.listBengkelTerdekat =
          await widget.controller.getTerdekatBengkels();
    }
  }

  // @override
  // stateUpdated(data) {
  //   return super.stateUpdated(data);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Home")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(20),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Selamat Datang, ${widget.controller.getUser.firstName}!')
                                .headingSmall(context)
                                .fontWeightBold(),
                            const Text('Layanan Apa yang anda butuhkan')
                                .bodyLarge(context)
                                .setColor(context, (color) => Colors.black54),
                          ],
                        ),
                        const Spacer(),
                        IconButton.filledTonal(
                          icon: const Icon(Icons.search),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const Gap(16),
                    Row(
                      children: [
                        TextButton.icon(
                          icon: const Icon(Icons.map),
                          onPressed: widget.controller.goToMap,
                          label: const Text("Lihat Map")
                              .bodyLarge(context)
                              .fontWeightBold(),
                        ),
                        const Spacer(),
                        TextButton.icon(
                          icon: const Icon(Icons.history),
                          onPressed: widget.controller.goToRiwayat,
                          label: const Text("Lihat Riwayat")
                              .bodyLarge(context)
                              .fontWeightBold(),
                        ),
                      ],
                    ),
                    const Gap(16),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    RowContentTitleHomeWidget(
                      title: 'Populer',
                    ),
                    Gap(8),
                  ],
                ),
              ),
              RowContentBodyBengkelWidget(
                list: widget.controller.listBengkelPopular,
                isLoading: !widget.controller.fetchListBengkelPopular,
                widget: (bengkel) => CardBengkelWidget(bengkel: bengkel),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Gap(24),
                    RowContentTitleHomeWidget(
                      title: 'Terdekat',
                    ),
                    Gap(8),
                  ],
                ),
              ),
              RowContentBodyBengkelWidget(
                list: widget.controller.listBengkelTerdekat,
                isLoading: !widget.controller.fetchListBengkelTerdekat,
                widget: (bengkel) => CardBengkelWidget(bengkel: bengkel),
              ),
              const Gap(28),
            ],
          ),
        ),
      ),
    );
  }
}

class RowContentTitleHomeWidget extends StatelessWidget {
  final String title;
  const RowContentTitleHomeWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title).titleLarge(context).fontWeightBold(),
            const Text('Lihat Semua')
                .bodyMedium(context)
                .setColor(context, (color) => Colors.black54),
          ],
        ),
      ],
    );
  }
}

class RowContentBodyBengkelWidget extends StatelessWidget {
  final List<Bengkel> list;
  final bool isLoading;
  final Widget Function(Bengkel value) widget;

  const RowContentBodyBengkelWidget({
    super.key,
    required this.list,
    required this.widget,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Skeletonizer(
        containersColor: Colors.grey.shade50,
        enabled: isLoading,
        child: Row(
          children: [
            const Gap(16),
            ...list.map((value) => widget(value)),
            const Gap(16),
          ],
        ),
      ),
    );
  }
}

class CardBengkelWidget extends StatelessWidget {
  final Bengkel bengkel;
  const CardBengkelWidget({super.key, required this.bengkel});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            bengkel.user?.imageUrl != null
                ? Image.network(
                    bengkel.user!.imageUrl,
                    height: 140,
                    width: 200,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    "bengkel.png",
                    height: 140,
                    width: 200,
                    fit: BoxFit.cover,
                  ).localAsset(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(bengkel.name).bodyMedium(context).fontWeightBold(),
                  Text(
                    bengkel.alamat,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ).bodyMedium(context).fontWeightLight(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
