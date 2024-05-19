import 'package:flutter/material.dart';
import 'package:flutter_app/app/controllers/pengendara_controller.dart';
import 'package:flutter_app/resources/widgets/avatar_widget.dart';
import 'package:flutter_app/resources/widgets/card_widget.dart';
import 'package:gap/gap.dart';
import 'package:nylo_framework/nylo_framework.dart';

class PengendaraProfile extends StatefulWidget {
  final PengendaraController controller;
  const PengendaraProfile({super.key, required this.controller});

  static String state = "pengendara_profile";

  @override
  createState() => _PengendaraProfileState();
}

class _PengendaraProfileState extends NyState<PengendaraProfile> {
  _PengendaraProfileState() {
    stateName = PengendaraProfile.state;
  }

  @override
  init() async {}

  @override
  stateUpdated(dynamic data) async {
    // e.g. to update this state from another class
    // updateState(PengendaraProfile.state, data: "example payload");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Profile")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Gap(20),
              Avatar(imageUrl: widget.controller.getUser.imageUrl),
              Gap(36),
              CardWidget(
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        widget.controller.name,
                      ),
                    ),
                    Divider(),
                    ListTile(
                      title: Text(widget.controller.getUser.email),
                    ),
                    Divider(),
                    ListTile(
                      title: Text(
                        widget.controller.getUser.role.name.capitalize(),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      title: Text(
                        widget.controller.getUser.pengendara?.noTelephone ??
                            'No.Telephone Belum di isi',
                      ),
                    ),
                  ],
                ),
              ),
              Gap(16),
              CardWidget(
                child: Column(
                  children: [
                    ListTile(
                      onTap: widget.controller.goToRiwayat,
                      title: Text(
                        "Riwayat",
                      ).fontWeightBold(),
                      trailing: Icon(
                        Icons.keyboard_arrow_right,
                      ),
                    ),
                    Divider(),
                    ListTile(
                      onTap: widget.controller.logout,
                      title: Text(
                        "Logout",
                      ).fontWeightBold(),
                      trailing: Icon(
                        Icons.logout,
                      ),
                    ),
                  ],
                ),
              ),
              Gap(16),
            ],
          ),
        ),
      ),
    );
  }
}
