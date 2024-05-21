// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_app/app/models/user.dart';
import 'package:nylo_framework/nylo_framework.dart';

import 'geo_location.dart';

/// Pengendara Model.

class Pengendara extends Model {
  final String id;
  final String noTelephone;
  final GeoLocation? location;
  final User? user;

  Pengendara({
    required this.id,
    this.user,
    required this.noTelephone,
    required this.location,
  });

  @override
  toJson() {
    return <String, dynamic>{
      'id': id,
      'noTelephone': noTelephone,
      'location': location?.toJson(),
      'user': user?.toJson(),
    };
  }

  factory Pengendara.empty() {
    return Pengendara.fromJson(null);
  }

  factory Pengendara.skeletonizer() {
    return Pengendara(
      id: 'id',
      noTelephone: '08313123123123',
      location: GeoLocation.skeletonizer(),
      user: User.skeletonizer(),
    );
  }

  factory Pengendara.fromJson(Map<String, dynamic>? map) {
    return Pengendara(
      id: map?['id'] ?? "-",
      noTelephone: map?['noTelephone'] ?? "-",
      location: map?['location'] == null
          ? null
          : GeoLocation.fromJson(map?['location'] as Map<String, dynamic>),
      user: map?['user'] == null
          ? null
          : User.fromJson(map?['user'] as Map<String, dynamic>),
    );
  }

  Pengendara copyWith({
    String? id,
    String? noTelephone,
    GeoLocation? location,
  }) {
    return Pengendara(
      id: id ?? this.id,
      noTelephone: noTelephone ?? this.noTelephone,
      location: location ?? this.location,
    );
  }
}
