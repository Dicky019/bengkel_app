import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/user.dart';
import 'package:nylo_framework/nylo_framework.dart';

/* Auth Route Guard
|--------------------------------------------------------------------------
| Checks if the User is authenticated.
| Learn more https://nylo.dev/docs/5.20.0/router#route-guards
|-------------------------------------------------------------------------- */

class PengendaraRouteGuard extends NyRouteGuard {
  PengendaraRouteGuard();

  @override
  Future<bool> canOpen(BuildContext? context, NyArgument? data) async {
    final User? user = await Auth.user<User>();
    dump("canOpen");
    return user?.role == Role.pengendara;
  }

  @override
  redirectTo(BuildContext? context, NyArgument? data) async {
    dump("redirectTo");
    await routeToAuth();
  }
}
