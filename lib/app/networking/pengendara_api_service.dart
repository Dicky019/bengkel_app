import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/pengendara.dart';
import 'package:flutter_app/config/storage_keys.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '/config/decoders.dart';
import 'package:nylo_framework/nylo_framework.dart';

// import 'dio/interceptors/bearer_auth_interceptor.dart';

class PengendaraApiService extends NyApiService {
  PengendaraApiService({BuildContext? buildContext})
      : super(buildContext, decoders: modelDecoders);

  @override
  // ignore: overridden_fields
  final interceptors = {
    // if (getEnv('APP_DEBUG') == true)
    PrettyDioLogger: PrettyDioLogger(requestBody: true, responseBody: true),
    // BearerAuthInterceptor: BearerAuthInterceptor()
  };

  @override
  String get baseUrl => getEnv('API_BASE_URL') + '/pengendara';

  /// Example API Request
  Future<Pengendara?> setPengendara(
    String? id,
    String userId,
    String noTelephone,
  ) async {
    final userToken = await StorageKey.userToken.read();
    userToken.toString().dump();
    return await network<Pengendara>(
      request: (request) => request.post(
        "",
        data: {
          "id": id,
          "noTelephone": noTelephone,
          "userId": userId,
        },
      ),
      bearerToken: userToken.toString(),
      handleSuccess: (response) async {
        return Pengendara.fromJson(response.data['data']);
      },
    );
  }
}
