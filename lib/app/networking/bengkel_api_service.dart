import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/bengkel.dart';
import 'package:flutter_app/config/storage_keys.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '/config/decoders.dart';
import 'package:nylo_framework/nylo_framework.dart';

class BengkelApiService extends NyApiService {
  BengkelApiService({BuildContext? buildContext})
      : super(buildContext, decoders: modelDecoders);

  @override
  // ignore: overridden_fields
  final interceptors = {
    if (getEnv('APP_DEBUG') == true)
      PrettyDioLogger: PrettyDioLogger(requestBody: true, responseBody: true),
    // BearerAuthInterceptor: BearerAuthInterceptor()
  };

  @override
  String get baseUrl => getEnv('API_BASE_URL') + '/bengkels';

  /// Example API Request
  Future<List<Bengkel>?> getPopulerBengkels() async {
    return await network<List<Bengkel>>(
      request: (request) => request.get(
        "/",
      ),
      bearerToken: await StorageKey.userToken.read(),
      handleSuccess: (response) {
        print(response.data);
        return List.from(response.data['data'])
            .map((json) => Bengkel.fromJson(json))
            .toList();
      },
      handleFailure: (error) {
        print(error);
      },
    );
  }
}
