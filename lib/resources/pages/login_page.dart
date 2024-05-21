import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/controllers/login_controller.dart';
import 'package:flutter_app/bootstrap/extensions.dart';
import 'package:gap/gap.dart';
import 'package:nylo_framework/nylo_framework.dart';

class LoginPage extends NyStatefulWidget<LoginController> {
  static const path = '/login';

  LoginPage({super.key}) : super(path, child: _LoginPageState());
}

class _LoginPageState extends NyState<LoginPage> {
  // @override
  // init() async {

  // }

  /// Use boot if you need to load data before the [view] is rendered.
  // @override
  // boot() async {
  //   final user = await widget.controller.getUser;
  //   if (user != null) {
  //     user.toJson().toString().dump();
  //     // widget.controller.setEventLogin(user);
  //   }
  // }

  // bool get useSkeletonizer => true;

  @override
  Widget view(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(title: Text("Login")),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          widget.controller.loginName = value == 0 ? "Pengendara" : "Montir";
          setState(() {});
        },
        currentIndex: widget.controller.loginName == "Pengendara" ? 0 : 1,
        items: const [
          BottomNavigationBarItem(
            label: 'Pengendara',
            icon: Icon(Icons.person_pin),
          ),
          BottomNavigationBarItem(
            label: 'Montir',
            icon: Icon(Icons.person_pin_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                getImageAsset("nylo_logo.png"),
                height: size.height * 0.4,
                width: size.height * 0.4,
              ),
              Text("Login ${widget.controller.loginName}")
                  .headingLarge(context)
                  .fontWeightBold(),
              const Gap(8),
              const Text("Enter your gmail below to login your account")
                  .setColor(
                context,
                (color) => color.primaryContent.withOpacity(0.6),
              ),
              const Gap(64),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(size.width, 48),
                ),
                onPressed: widget.controller.loginGoogle,
                label: const Text("Google").bodyLarge(context).fontWeightBold(),
                icon: Icon(
                  EvaIcons.google,
                  color: context.color.buttonBackground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
