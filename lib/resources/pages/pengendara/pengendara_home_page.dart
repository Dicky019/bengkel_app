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
  init() async {}

  @override
  stateUpdated(dynamic data) async {
    // e.g. to update this state from another class
    // updateState(PengendaraHome.state, data: "example payload");
  }

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
                    Gap(20),
                    Text('Selamat Datang, ${widget.controller.getUser.firstName}!')
                        .headingSmall(context)
                        .fontWeightBold(),
                    Text('Layanan Apa yang anda butuhkan')
                        .bodyLarge(context)
                        .setColor(context, (color) => Colors.black54),
                    Gap(24),
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(16.0),
                          ),
                        ),
                        hintText: 'Search Bengkel...',
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Gap(24),
                    RowContentTitleHomeWidget(
                      title: 'Populer',
                    ),
                    Gap(8),
                  ],
                ),
              ),
              RowContentBodyBengkelWidget(
                futureList: widget.controller.getPopulerBengkels,
                widget: (bengkel) => CardBengkelWidget(bengkel: bengkel),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                futureList: widget.controller.getPopulerBengkels,
                widget: (bengkel) => CardBengkelWidget(bengkel: bengkel),
              ),
              Gap(28),
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
            Text('Lihat Semua')
                .bodyMedium(context)
                .setColor(context, (color) => Colors.black54),
          ],
        ),
      ],
    );
  }
}

class RowContentBodyBengkelWidget<T> extends StatelessWidget {
  final Future<List<Bengkel>> Function() futureList;
  final Widget Function(Bengkel value) widget;
  const RowContentBodyBengkelWidget({
    super.key,
    required this.futureList,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: FutureBuilder(
        future: futureList(),
        builder: (context, snapshot) {
          return Skeletonizer(
            containersColor: Colors.grey.shade50,
            enabled: !snapshot.hasData,
            child: Row(
              children: [
                Gap(16),
                ...(snapshot.data ??
                        List.filled(
                          4,
                          Bengkel.skeletonizer(),
                        ))
                    .map((value) => widget(value))
                    .toList(),
                Gap(16),
              ],
            ),
          );
        },
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
            bengkel.image != null
                ? Image.network(
                    bengkel.image!,
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
