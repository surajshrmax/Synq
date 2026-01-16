import 'package:dio/dio.dart';
import 'package:synq/core/storage/secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorage storage;

  AuthInterceptor({required this.storage});
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await storage.getAccessToken();
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }
}
