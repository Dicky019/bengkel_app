import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

class PangendaraMapPage extends NyStatefulWidget {
  static const path = '/pangendara-map';

  PangendaraMapPage({super.key})
      : super(path, child: _PangendaraMapPageState());
}

class _PangendaraMapPageState extends NyState<PangendaraMapPage> {
  @override
  init() async {}

  /// Use boot if you need to load data before the [view] is rendered.
  // @override
  // boot() async {
  //
  // }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pangendara Map")),
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
