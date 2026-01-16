import 'package:dio/dio.dart';
import 'package:synq/core/di/service_locator.dart';
import 'package:synq/core/network/interceptors/auth_interceptors.dart';
import 'package:synq/core/storage/secure_storage.dart';

class DioFactory {
  static Dio create(String baseUrl) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: Duration(seconds: 10),
        sendTimeout: Duration(seconds: 10),
        receiveTimeout: Duration(seconds: 10),
        contentType: "application/json",
      ),
    );

    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    dio.interceptors.add(AuthInterceptor(storage: getIt<SecureStorage>()));

    return dio;
  }
}
