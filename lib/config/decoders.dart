import 'package:flutter_app/app/networking/pemesanan_api_service.dart';

import '/app/models/pemesanan.dart';
import '/app/networking/bengkel_api_service.dart';
import '/app/controllers/pengendara_controller.dart';
import '/app/controllers/home_controller.dart';
import '/app/controllers/login_controller.dart';
import '/app/models/bengkel.dart';
import '/app/models/geo_location.dart';
import '/app/models/user.dart';
import '/app/networking/api_service.dart';
import '/app/networking/auth_api_service.dart';
import '/app/networking/pengendara_api_service.dart';

/* Model Decoders
|--------------------------------------------------------------------------
| Model decoders are used in 'app/networking/' for morphing json payloads
| into Models.
|
| Learn more https://nylo.dev/docs/5.20.0/decoders#model-decoders
|-------------------------------------------------------------------------- */

final Map<Type, dynamic> modelDecoders = {
  List<User>: (data) =>
      List.from(data).map((json) => User.fromJson(json)).toList(),
  //
  User: (data) => User.fromJson(data),

  // User: (data) => User.fromJson(data),

  List<Bengkel>: (data) =>
      List.from(data).map((json) => Bengkel.fromJson(json)).toList(),

  Bengkel: (data) => Bengkel.fromJson(data),

  List<Pemesanan>: (data) =>
      List.from(data).map((json) => Pemesanan.fromJson(json)).toList(),

  Pemesanan: (data) => Pemesanan.fromJson(data),

  List<GeoLocation>: (data) =>
      List.from(data).map((json) => GeoLocation.fromJson(json)).toList(),

  GeoLocation: (data) => GeoLocation.fromJson(data),
};

/* API Decoders
| -------------------------------------------------------------------------
| API decoders are used when you need to access an API service using the
| 'api' helper. E.g. api<MyApiService>((request) => request.fetchData());
|
| Learn more https://nylo.dev/docs/5.20.0/decoders#api-decoders
|-------------------------------------------------------------------------- */

final Map<Type, dynamic> apiDecoders = {
  ApiService: () => ApiService(),

  // ...

  AuthApiService: AuthApiService(),

  PengendaraApiService: PengendaraApiService(),
  BengkelApiService: BengkelApiService(),
  PemesananApiService: PemesananApiService(),
};

/* Controller Decoders
| -------------------------------------------------------------------------
| Controller are used in pages.
|
| Learn more https://nylo.dev/docs/5.20.0/controllers
|-------------------------------------------------------------------------- */
final Map<Type, dynamic> controllers = {
  HomeController: () => HomeController(),

  // ...

  LoginController: () => LoginController(),

  PengendaraController: () => PengendaraController(),
};
