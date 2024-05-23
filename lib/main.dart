import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/user.dart';
import 'package:flutter_app/firebase_options.dart';
import 'package:flutter_app/resources/pages/login_page.dart';
import 'package:flutter_app/resources/pages/montir/montir_page.dart';
import 'package:flutter_app/resources/pages/pengendara_page.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '/bootstrap/app.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'bootstrap/boot.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configLoading();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Nylo nylo = await Nylo.init(setup: Boot.nylo, setupFinished: Boot.finished);

  final User? user = Backpack.instance.auth();

  if (user != null) {
    nylo.setInitialRoute(
      user.role == Role.motir ? MontirPage.path : PengendaraPage.path,
    );
  } else {
    nylo.setInitialRoute(LoginPage.path);
  }

  runApp(
    AppBuild(
      navigatorKey: NyNavigator.instance.router.navigatorKey,
      onGenerateRoute: nylo.router!.generator(),
      debugShowCheckedModeBanner: false,
      initialRoute: nylo.getInitialRoute(),
      navigatorObservers: nylo.getNavigatorObservers(),
      themeData: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
      ),
      builder: EasyLoading.init(),
    ),
  );
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(seconds: 3)
    ..indicatorType = EasyLoadingIndicatorType.chasingDots
    ..loadingStyle = EasyLoadingStyle.custom
    ..maskType = EasyLoadingMaskType.custom
    ..indicatorSize = 40
    ..boxShadow = [
      BoxShadow(
        color: Colors.lightBlue.shade100.withOpacity(0.2),
        spreadRadius: 3,
        blurRadius: 10,
        offset: const Offset(0, 1), // changes position of shadow
      ),
    ]
    ..progressColor = Colors.lightBlue
    ..backgroundColor = Colors.lightBlue.shade100
    ..indicatorColor = Colors.lightBlue.shade900
    ..textColor = Colors.black
    ..maskColor = Colors.lightBlue.shade100.withOpacity(0.3);
}
