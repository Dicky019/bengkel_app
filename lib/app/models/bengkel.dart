import 'package:flutter_app/app/models/geo_location.dart';
import 'package:nylo_framework/nylo_framework.dart';

/// Bengkel Model.

class Bengkel extends Model {
  final String name;
  final String noTelephone;
  final String alamat;
  final String? image;
  final GeoLocation? geo;

  Bengkel({
    required this.name,
    required this.noTelephone,
    required this.alamat,
    required this.image,
    required this.geo,
  });

  factory Bengkel.fromJson(data) {
    return Bengkel(
      name: data['name'] ?? "-",
      noTelephone: data['no_telephone'] ?? "-",
      alamat: data['alamat'] ?? "-",
      image: data['image'] ?? null,
      geo: data['geo'] == null
          ? null
          : GeoLocation.fromJson(data['geo'] as Map<String, dynamic>),
    );
  }

  factory Bengkel.skeletonizer() {
    return Bengkel(
      name: "Dicky Darmawan",
      noTelephone: "0813-5583-4769",
      alamat:
          'https://media.istockphoto.com/id/1477215272/id/vektor/desain-logo-bengkel-piston-gear-otomotif-desain-logo-piston-dan-roda-gigi-ikon-vektor-garis.jpg?s=1024x1024&w=is&k=20&c=D50zqkCMQFEQxWMR6xnAIsEYuTnVCBzXstk2XZBBzyE=',
      image: null,
      geo: null,
    );
  }

  factory Bengkel.empty() {
    return Bengkel(
      name: "Dicky",
      noTelephone: "-",
      alamat: "-",
      image: null,
      geo: null,
    );
  }

  @override
  toJson() {
    return {
      'name': name,
      'no_telephone': noTelephone,
      'alamat': alamat,
      'geo': geo?.toJson(),
    };
  }
}
