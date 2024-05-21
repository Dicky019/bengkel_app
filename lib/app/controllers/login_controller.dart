import 'package:flutter_app/app/events/login_event.dart';
import 'package:flutter_app/app/models/user.dart';
import 'package:flutter_app/app/networking/auth_api_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nylo_framework/nylo_framework.dart';

import '/app/controllers/controller.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class LoginController extends Controller {
  @override
  bool get singleton => true;


  String loginName = "Pengendara";

  final _clientId = getEnv(TargetPlatform.iOS == defaultTargetPlatform
      ? 'GOOGLE_CLIEND_ID_IOS'
      : "GOOGLE_CLIEND_ID_ANDROID");

  Future loginGoogle() async {
    // state.dump();

    try {
      GoogleSignIn googleSignIn = GoogleSignIn(
        // Optional clientId
        // clientId: 'your-client_id.apps.googleusercontent.com',
        clientId: _clientId,
      );

      if (googleSignIn.currentUser == null) {
        await googleSignIn.signIn();
      }

      final currentUser = googleSignIn.currentUser;

      if (currentUser == null) {
        "currentUser == null)".dump();
        return;
      }

      EasyLoading.show();

      final authentication = await currentUser.authentication;

      final accessToken = authentication.accessToken.toString();

      final User? user =
          await api<AuthApiService>((request) => request.googleUser(
                role: loginName,
                accessToken: accessToken,
              ));
      // event<LoginEvent>(data: u);
      if (user != null) {
        await Auth.login(user);
        EasyLoading.dismiss();
        setEventLogin(user);
      }
    } catch (e) {
      e.toString().dump();
    }
    EasyLoading.dismiss();
  }

  void setEventLogin(User user) {
    event<LoginEvent>(data: {"user": user.toJson()});
  }
}
