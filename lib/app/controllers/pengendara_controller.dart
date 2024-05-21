import 'package:flutter_app/app/models/pemesanan.dart';
import 'package:flutter_app/app/networking/pemesanan_api_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nylo_framework/nylo_framework.dart';

import '/app/controllers/controller.dart';
import 'package:flutter/widgets.dart';

import '../models/user.dart';

import '/app/models/bengkel.dart';
import '/app/models/pengendara.dart';
import '/app/networking/auth_api_service.dart';
import '/app/networking/bengkel_api_service.dart';
import '/app/networking/pengendara_api_service.dart';
import '/config/storage_keys.dart';
import '/resources/pages/login_page.dart';
import '/resources/pages/pangendara_riwayat_page.dart';
import '/resources/pages/pengendara/pengendara_home_page.dart';
import '/resources/pages/pengendara/pengendara_konsultasi_page.dart';
import '/resources/pages/pengendara/pengendara_profile_page.dart';
import '/resources/pages/pengendara_map.dart';

class PengendaraController extends Controller {
  // List data
  var fetchListBengkelPopular = false;
  var listBengkelPopular = List.filled(
    4,
    Bengkel.skeletonizer(),
  );

  var fetchListBengkelTerdekat = false;
  var listBengkelTerdekat = List.filled(
    4,
    Bengkel.skeletonizer(),
  );

  var fetchListPemesanan = false;
  var listPemesanan = List.filled(
    10,
    Pemesanan.skeletonizer(),
  );

  // @override
  // construct(BuildContext context) {
  //   super.construct(context);
  // }

  @override
  bool get singleton => true;

  User get getUser => Auth.user<User>()!;
  bool get isPengendaraNull => Auth.user<User>()!.pengendara == null;

  String get name => "${getUser.firstName} ${getUser.lastName}";

  int bottomNavIndex = 0;

  init() async {
    final User? userAndDetail =
        await api<AuthApiService>((request) => request.getMe());
    if (userAndDetail == null) {
      routeTo(LoginPage.path, navigationType: NavigationType.pushAndForgetAll);
    }

    await Auth.login(userAndDetail ?? getUser);
  }

  Future<List<Bengkel>> getPopulerBengkels() async {
    final List<Bengkel>? bengkels =
        await api<BengkelApiService>((request) => request.getPopulerBengkels());
    fetchListBengkelPopular = true;
    return bengkels ?? [];
  }

  Future<List<Bengkel>> getTerdekatBengkels() async {
    final List<Bengkel>? bengkels = await api<BengkelApiService>(
        (request) => request.getTerdekatBengkels());
    fetchListBengkelTerdekat = true;
    return bengkels ?? [];
  }

  Future<List<Pemesanan>> getPemesanans() async {
    final List<Pemesanan>? pemesanans =
        await api<PemesananApiService>((request) => request.getPemesanans());
    fetchListPemesanan = true;
    return pemesanans ?? [];
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

  goToMap() async {
    routeTo(
      PangendaraMapPage.path,
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
