import 'package:flutter_app/app/models/bengkel.dart';
import 'package:flutter_app/app/models/pengendara.dart';
import 'package:nylo_framework/nylo_framework.dart';

class Pemesanan extends Model {
  final String id;
  final String messagesId;
  final String merekMotor;
  final String imageMotor;
  final String description;
  final Pengendara pengendara;
  final Bengkel bengkel;

  Pemesanan({
    required this.id,
    required this.messagesId,
    required this.merekMotor,
    required this.imageMotor,
    required this.description,
    required this.pengendara,
    required this.bengkel,
  });

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'messagesId': messagesId,
      'merek_motor': merekMotor,
      'image_motor': imageMotor,
      'description': description,
      'pengendara': pengendara.toJson(),
      'bengkel': bengkel.toJson(),
    };
  }

  factory Pemesanan.skeletonizer() {
    return Pemesanan(
      id: "id",
      messagesId: "messagesId",
      merekMotor: "Merek Motor",
      description: "description",
      pengendara: Pengendara.skeletonizer(),
      imageMotor: "imageMotor",
      bengkel: Bengkel.skeletonizer(),
    );
  }

  factory Pemesanan.empty() {
    return Pemesanan.fromJson(null);
  }

  factory Pemesanan.fromJson(Map<String, dynamic>? map) {
    return Pemesanan(
      id: map?['id'] ?? "-",
      messagesId: map?['messagesId'] ?? "-",
      merekMotor: map?['merek_motor'] ?? "-",
      imageMotor: map?['image_motor'] ?? "-",
      description: map?['description'] ?? "-",
      pengendara: Pengendara.fromJson(map?['pengendara']),
      bengkel: Bengkel.fromJson(map?['bengkel']),
    );
  }
}
