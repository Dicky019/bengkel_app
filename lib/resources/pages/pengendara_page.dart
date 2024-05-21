import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_app/config/storage_keys.dart';
import 'package:flutter_app/resources/widgets/pengendara_detail_form_widget.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:flutter/material.dart';
import '/app/controllers/pengendara_controller.dart';

class PengendaraPage extends NyStatefulWidget<PengendaraController> {
  static const path = '/pengendara';

  PengendaraPage({super.key}) : super(path, child: PengendaraPageState());
}

class PengendaraPageState extends NyState<PengendaraPage> {
  final noTel = TextEditingController(
      text: getEnv('APP_DEBUG') ? "+62 813-558-347-69" : null);

  @override
  boot() async {
    await widget.controller.init();
    widget.controller.bottomNavIndex =
        await StorageKey.navIndex.read(defaultValue: 0);
    // widget.controller.isPengendaraNull.dump();
    if (widget.controller.isPengendaraNull) {
      _showCustomDialog(
        context,
        noTel,
        (noTel) =>
            widget.controller.setPengendaraDetail(noTel).whenComplete(() {
          Navigator.pop(context);
        }),
      );
    }
  }

  @override
  void dispose() {
    noTel.dispose();
    super.dispose();
  }

  @override
  Widget view(BuildContext context) {
    final bodys = widget.controller.listNavWidget(widget.controller);
    final bottomNavIndex = widget.controller.bottomNavIndex;
    return Scaffold(
      body: bodys[bottomNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        unselectedIconTheme: const IconThemeData(color: Colors.white54),
        selectedIconTheme: const IconThemeData(color: Colors.white),
        onTap: (index) {
          setState(() => widget.controller.bottomNavIndex = index);
          widget.controller.onChangeNav(index);
        },
        currentIndex: bottomNavIndex,
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(EvaIcons.home),
          ),
          BottomNavigationBarItem(
            label: 'Konsultasi',
            icon: Icon(Icons.chat),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(EvaIcons.person),
          ),
        ],
        //other params
      ),
    );
  }
}

_showCustomDialog(BuildContext context, TextEditingController controller,
    void Function(String noTel) onSubmit) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return PengendaraDetailForm(
        controller: controller,
        onSubmit: () => onSubmit(controller.text),
      );
    },
  );
}
