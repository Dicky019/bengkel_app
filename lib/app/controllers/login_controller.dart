import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/app/events/login_event.dart';
import 'package:flutter_app/app/models/user.dart' as my;
import 'package:flutter_app/app/networking/auth_api_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nylo_framework/nylo_framework.dart';

import '/app/controllers/controller.dart';
// import 'package:flutter/foundation.dart'
//     show defaultTargetPlatform, TargetPlatform;

class LoginController extends Controller {
  @override
  bool get singleton => true;

  String loginName = "Pengendara";

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future loginGoogle() async {
    // state.dump();

    try {
      final authentication = await signInWithGoogle();

      EasyLoading.show();

      // final authentication = await currentUser.authentication;

      // final accessToken = authentication.accessToken.toString();
      if (authentication.credential?.accessToken == null) {
        throw Exception('accessToken == null');
      }

      final my.User? user =
          await api<AuthApiService>((request) => request.googleUser(
                role: loginName,
                accessToken: authentication.credential!.accessToken!,
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

  void setEventLogin(my.User user) {
    event<LoginEvent>(data: {"user": user.toJson()});
  }
}
