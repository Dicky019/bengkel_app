import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/user.dart';
import 'package:flutter_app/config/storage_keys.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '/config/decoders.dart';
import 'package:nylo_framework/nylo_framework.dart';

// import 'dio/interceptors/bearer_auth_interceptor.dart';

class AuthApiService extends NyApiService {
  AuthApiService({BuildContext? buildContext})
      : super(buildContext, decoders: modelDecoders);

  @override
  String get baseUrl => getEnv('API_BASE_URL') + "/auth";

  @override
  // ignore: overridden_fields
  final interceptors = {
    if (getEnv('APP_DEBUG') == true)
      PrettyDioLogger: PrettyDioLogger(requestBody: true, responseBody: true),
    // BearerAuthInterceptor: BearerAuthInterceptor()
  };

  /// Example API Request
  Future<User?> googleUser({
    required String accessToken,
    required String role,
  }) async {
    try {
      final User? user = await network<User>(
        request: (request) => request.post(
          "/google-user",
          data: {
            "accessToken": accessToken,
            "role": role.toLowerCase(),
          },
        ),
        handleSuccess: (response) async {
          await StorageKey.userToken.store(response.data['token']);
          return User.fromJson(response.data['data']);
        },
      );

      // if (user != null) {
      //   return await getMe();
      // }

      return user;
    } catch (e) {
      e.toString().dump();
    }

    return null;
  }

  Future<User?> getMe() async {
    try {
      final userToken = await StorageKey.userToken.read();
      userToken.toString().dump();
      final User? user = await network<User>(
        request: (request) => request.get(
          "/me-user",
        ),
        bearerToken: userToken.toString(),
        handleSuccess: (response) => User.fromJsonPengendara(
          response.data['data']['user'],
          response.data['data']['user_detail'],
        ),
      );

      return user;
    } catch (e) {
      e.toString().dump();
    }

    return null;
  }
}
