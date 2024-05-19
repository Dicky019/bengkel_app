import 'package:nylo_framework/nylo_framework.dart';

/// GeoLocation Model.

class GeoLocation extends Model {
  final String id;
  final double lat;
  final double long;

  GeoLocation({
    required this.id,
    required this.lat,
    required this.long,
  });

  @override
  toJson() {
    return <String, dynamic>{
      'id': id,
      'lat': lat,
      'long': long,
    };
  }

  factory GeoLocation.fromJson(Map<String, dynamic> map) {
    return GeoLocation(
      id: map['id'] as String,
      lat: double.tryParse(map['lat'] as String) ?? 0.0,
      long: double.tryParse(map['long'] as String) ?? 0.0,
    );
  }
}
