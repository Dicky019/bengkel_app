import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/pemesanan.dart';
import 'package:flutter_app/config/storage_keys.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '/config/decoders.dart';
import 'package:nylo_framework/nylo_framework.dart';

class PemesananApiService extends NyApiService {
  PemesananApiService({BuildContext? buildContext})
      : super(buildContext, decoders: modelDecoders);

  @override
  // ignore: overridden_fields
  final interceptors = {
    if (getEnv('APP_DEBUG') == true)
      PrettyDioLogger: PrettyDioLogger(requestBody: true, responseBody: true),
    // BearerAuthInterceptor: BearerAuthInterceptor()
  };

  @override
  String get baseUrl => getEnv('API_BASE_URL') + '/pemesanan';

  /// Example API Request
  Future<List<Pemesanan>?> getPemesanans(
    String id,
  ) async {
    return await network<List<Pemesanan>>(
      request: (request) =>
          request.get("/", queryParameters: {'id': id, 'role': 'pengendara'}),
      bearerToken: await StorageKey.userToken.read(),
      handleSuccess: (response) {
        dump(response.data['data']);
        return List.from(response.data['data'])
            .map((json) => Pemesanan.fromJson(json))
            .toList();
        // return [];
      },
      handleFailure: (error) {
        dump(error);
      },
    );
  }

  Future<Pemesanan?> getPemesanan(
    String id,
  ) async {
    return await network<Pemesanan>(
      request: (request) => request.get("/$id"),
      bearerToken: await StorageKey.userToken.read(),
      handleSuccess: (response) {
        dump(response.data['data']);
        return Pemesanan.fromJson(response.data['data']);
      },
      handleFailure: (error) {
        dump(error);
      },
    );
  }
}
