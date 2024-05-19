import 'dart:developer';

import 'package:flutter_app/app/models/bengkel.dart';
import 'package:flutter_app/app/models/pengendara.dart';
import 'package:flutter_app/app/networking/auth_api_service.dart';
import 'package:flutter_app/app/networking/bengkel_api_service.dart';
import 'package:flutter_app/app/networking/pengendara_api_service.dart';
import 'package:flutter_app/config/storage_keys.dart';
import 'package:flutter_app/resources/pages/login_page.dart';
import 'package:flutter_app/resources/pages/pangendara_riwayat_page.dart';
import 'package:flutter_app/resources/pages/pengendara/pengendara_home_page.dart';
import 'package:flutter_app/resources/pages/pengendara/pengendara_konsultasi_page.dart';
import 'package:flutter_app/resources/pages/pengendara/pengendara_profile_page.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nylo_framework/nylo_framework.dart';

import '../models/user.dart';
import '/app/controllers/controller.dart';
import 'package:flutter/widgets.dart';

class PengendaraController extends Controller {
  @override
  construct(BuildContext context) {
    super.construct(context);
  }

  @override
  bool get singleton => true;

  User get getUser => Auth.user<User>()!;
  bool get isPengendaraNull => Auth.user<User>()!.pengendara == null;

  String get name => getUser.firstName + " " + getUser.lastName;

  int bottomNavIndex = 0;

  init() async {
    final User? userAndDetail =
        await api<AuthApiService>((request) => request.getMe());
    if (userAndDetail == null) {
      routeTo(LoginPage.path, navigationType: NavigationType.pushAndForgetAll);
    }

    await Auth.login(userAndDetail != null ? userAndDetail : getUser);
  }

  Future<List<Bengkel>> getPopulerBengkels() async {
    final List<Bengkel>? bengkels =
        await api<BengkelApiService>((request) => request.getPopulerBengkels());
    return bengkels ?? [];
  }

  List<Widget> listNavWidget(PengendaraController controller) => [
        PengendaraHome(controller: controller),
        PengendaraKonsultasi(controller: controller),
        PengendaraProfile(controller: controller),
      ];

  logout() async {
    onChangeNav(0);
    await Auth.logout();
    routeTo(
      "/login",
      navigationType: NavigationType.pushAndForgetAll,
    );
  }

  goToRiwayat() async {
    routeTo(
      PangendaraRiwayatPage.path,
    );
  }

  Future onChangeNav(int index) async {
    // or
    await StorageKey.navIndex.store(index);
  }

  Future setPengendaraDetail(String noTel) async {
    EasyLoading.show();
    final Pengendara? pengendara =
        await api<PengendaraApiService>((request) => request.setPengendara(
              getUser.pengendara?.id,
              getUser.id,
              noTel,
            ));

    if (pengendara != null) {
      final user = getUser.copyWith(pengendara: pengendara);
      await Auth.login(user);
    }

    EasyLoading.dismiss();
  }
}
