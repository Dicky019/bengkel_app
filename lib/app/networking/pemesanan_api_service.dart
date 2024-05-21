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
  Future<List<Pemesanan>?> getPemesanans() async {
    return await network<List<Pemesanan>>(
      request: (request) => request.get(
        "/",
      ),
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
}
