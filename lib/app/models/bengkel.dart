import 'package:flutter_app/app/models/geo_location.dart';
import 'package:flutter_app/app/models/user.dart';
import 'package:nylo_framework/nylo_framework.dart';

/// Bengkel Model.

class Bengkel extends Model {
  final String id;
  final String name;
  final String noTelephone;
  final String alamat;
  // final String? image;
  final GeoLocation? geo;
  final User? user;

  Bengkel({
    required this.id,
    required this.name,
    required this.noTelephone,
    required this.alamat,
    required this.user,
    // required this.image,
    required this.geo,
  });

  factory Bengkel.fromJson(data) {
    return Bengkel(
      id: data['id'] ?? "-",
      name: data['name'] ?? "-",
      noTelephone: data['no_telephone'] ?? "-",
      alamat: data['alamat'] ?? "-",
      user: data['user'] == null
          ? null
          : User.fromJson(data['user'] as Map<String, dynamic>),
      geo: data['geo'] == null
          ? null
          : GeoLocation.fromJson(data['geo'] as Map<String, dynamic>),
    );
  }

  factory Bengkel.skeletonizer() {
    return Bengkel(
      id: "id",
      name: "Dicky Darmawan",
      noTelephone: "0813-5583-4769",
      alamat:
          'https://media.istockphoto.com/id/1477215272/id/vektor/desain-logo-bengkel-piston-gear-otomotif-desain-logo-piston-dan-roda-gigi-ikon-vektor-garis.jpg?s=1024x1024&w=is&k=20&c=D50zqkCMQFEQxWMR6xnAIsEYuTnVCBzXstk2XZBBzyE=',
      // image: null,
      geo: null, user: null,
    );
  }

  factory Bengkel.empty() {
    return Bengkel.fromJson(null);
  }

  @override
  toJson() {
    return {
      'id': id,
      'name': name,
      'no_telephone': noTelephone,
      'alamat': alamat,
      'geo': geo?.toJson(),
      'user': user?.toJson(),
    };
  }
}
