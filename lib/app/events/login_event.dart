import 'package:flutter_app/app/models/user.dart';
import 'package:flutter_app/resources/pages/montir/montir_page.dart';
import 'package:flutter_app/resources/pages/pengendara_page.dart';
import 'package:nylo_framework/nylo_framework.dart';

class LoginEvent implements NyEvent {
  @override
  final listeners = {
    RoleEvent: RoleEvent(),
  };
}

class RoleEvent extends NyListener {
  @override
  handle(dynamic event) async {
    // handle the payload from event
    final isNullUser = event['user'] == null;
    if (isNullUser) {
      return;
    }

    final user = User.fromJson(event['user']);

    event.toString().dump();

    event['user'].toString().dump();

    if (user.role == Role.pengendara) {
      return routeTo(
        PengendaraPage.path,
        navigationType: NavigationType.pushAndForgetAll,
      );
    }

    if (user.role == Role.motir) {
      return routeTo(
        MontirPage.path,
        navigationType: NavigationType.pushAndForgetAll,
      );
    }
    // final
  }
}
