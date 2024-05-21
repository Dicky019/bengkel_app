import 'package:nylo_framework/nylo_framework.dart';

import '/resources/pages/pengendara_map.dart';
import '/resources/pages/pangendara_riwayat_page.dart';
import '/resources/pages/montir/montir_page.dart';
import '/routes/guards/pengendara_route_guard.dart';
import '/resources/pages/pengendara_page.dart';
import '/resources/pages/login_page.dart';

import 'guards/montir_route_guard.dart';

/* App Router
|--------------------------------------------------------------------------
| * [Tip] Create pages faster 🚀
| Run the below in the terminal to create new a page.
| "dart run nylo_framework:main make:page profile_page"
| Learn more https://nylo.dev/docs/5.20.0/router
|-------------------------------------------------------------------------- */

appRouter() => nyRoutes((router) {
      // Add your routes here

      // PengendaraPage using grouped routes
      router.group(
          () => {
                "route_guards": [PengendaraRouteGuard()],
                "prefix": "/pengendara"
              }, (router) {
        router.route(
          PengendaraPage.path,
          (_) => PengendaraPage(),
        );
        router.route(
          PangendaraRiwayatPage.path,
          (context) => PangendaraRiwayatPage(),
        );
        router.route(
          PangendaraMapPage.path,
          (context) => PangendaraMapPage(),
        );
      });

      // MontirPage using grouped routes
      router.group(
          () => {
                "route_guards": [MontirRouteGuard()],
                "prefix": "/montir"
              }, (router) {
        router.route(
          MontirPage.path,
          (_) => MontirPage(),
        );
      });

      router.route(
        LoginPage.path,
        (context) => LoginPage(),
        authPage: true,
        // initialRoute: true,
      );
    });
