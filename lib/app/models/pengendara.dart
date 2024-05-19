import 'package:nylo_framework/nylo_framework.dart';

import 'geo_location.dart';

/// Pengendara Model.

class Pengendara extends Model {
  final String id;
  final String noTelephone;
  final GeoLocation? location;

  Pengendara({
    required this.id,
    required this.noTelephone,
    required this.location,
  });

  @override
  toJson() {
    return <String, dynamic>{
      'id': id,
      'noTelephone': noTelephone,
      'location': location?.toJson(),
    };
  }

  factory Pengendara.fromJson(Map<String, dynamic> map) {
    return Pengendara(
      id: map['id'] as String,
      noTelephone: map['noTelephone'] as String,
      location: map['location'] == null
          ? null
          : GeoLocation.fromJson(map['location'] as Map<String, dynamic>),
    );
  }
}
