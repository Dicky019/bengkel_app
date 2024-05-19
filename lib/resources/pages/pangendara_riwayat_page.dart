import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

class PangendaraRiwayatPage extends NyStatefulWidget {
  static const path = '/pangendara-riwayat';
  
  PangendaraRiwayatPage({super.key}) : super(path, child: _PangendaraRiwayatPageState());
}

class _PangendaraRiwayatPageState extends NyState<PangendaraRiwayatPage> {

  @override
  init() async {

  }
  
  /// Use boot if you need to load data before the [view] is rendered.
  // @override
  // boot() async {
  //
  // }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pangendara Riwayat")
      ),
      body: SafeArea(
         child: Container(),
      ),
    );
  }
}
