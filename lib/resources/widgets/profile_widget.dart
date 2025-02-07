import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key, this.height, this.width, this.image});
  final double? height;
  final double? width;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.black.withOpacity(.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: const SizedBox(
        height: 100,
        width: 100,
        child: Icon(
          EvaIcons.person,
          size: 80,
        ),
      ),
    );
  }
}
