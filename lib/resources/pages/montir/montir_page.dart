import 'package:nylo_framework/nylo_framework.dart';
import 'package:flutter/material.dart';
import '/resources/widgets/safearea_widget.dart';
import '/app/controllers/home_controller.dart';

class MontirPage extends NyStatefulWidget<HomeController> {
  static const path = '/home';

  MontirPage({super.key}) : super(path, child: MontirPageState());
}

class MontirPageState extends NyState<MontirPage> {
  @override
  boot() async {
    final user = widget.controller.getUser;
    (user?.toJson().toString() ?? "kosong").dump();
  }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Montir"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await Auth.logout();
              routeTo(
                "/login",
                navigationType: NavigationType.pushAndForgetAll,
              );
            },
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: SafeAreaWidget(
        child: ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.black26,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    "noimage.png",
                    fit: BoxFit.cover,
                  ).localAsset(),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => const Divider(),
          itemCount: 12,
        ),
      ),
    );
  }

  bool get isThemeDark =>
      ThemeProvider.controllerOf(context).currentThemeId ==
      getEnv('DARK_THEME_ID');
}
