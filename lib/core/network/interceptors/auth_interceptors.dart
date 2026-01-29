import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:synq/core/storage/secure_storage.dart';
import 'package:synq/features/auth/data/models/login_response.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorage storage;
  final Dio dio;

  bool _isRefreshing = false;
  final List<Function()> requestQueues = [];

  AuthInterceptor({required this.storage, required this.dio});

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

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 &&
        !_isRefreshRequest(err.requestOptions)) {
      return _refreshToken(err, handler);
    }
  }

  bool _isRefreshRequest(RequestOptions options) {
    return options.path.contains("/auth/refresh");
  }

  Future<void> _refreshToken(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final requestOptions = err.requestOptions;

    if (_isRefreshing) {
      requestQueues.add(() async {
        final response = await dio.fetch(requestOptions);
        handler.resolve(response);
      });
      return;
    }

    _isRefreshing = true;

    try {
      final refreshToken = await storage.getRefreshToken();
      if (refreshToken == null) throw Exception("Token not found");

      final response = await dio.post(
        "/auth/refresh-token",
        data: {'refreshToken': refreshToken},
      );

      Map<String, dynamic> json = response.data;

      var tokens = AuthToken(
        accessToken: json['accessToken'],
        refreshTokne: json['refreshToken'],
      );
      await storage.saveToken(tokens);
    } catch (e) {}
  }

  Future<Response> _retryRequest(RequestOptions requestOptions) async {
    var options = Options(
      method: requestOptions.method,
      headers: {
        ...requestOptions.headers,
        "Authrorization": "Bearer ${await storage.getAccessToken()}",
      },
    );

    return dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}

