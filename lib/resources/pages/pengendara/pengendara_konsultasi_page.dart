import 'package:flutter/material.dart';
import 'package:flutter_app/app/controllers/pengendara_controller.dart';
import 'package:gap/gap.dart';
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

  @override
  init() async {}

  @override
  stateUpdated(dynamic data) async {
    // e.g. to update this state from another class
    // updateState(PengendaraKonsultasi.state, data: "example payload");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Konsultasi")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Gap(20),
            Text('Konsultasi').headingLarge(context),
          ],
        ),
      ),
    );
  }
}
