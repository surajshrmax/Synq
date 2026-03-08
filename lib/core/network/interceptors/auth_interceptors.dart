import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:synq/core/storage/secure_storage.dart';
import 'package:synq/features/auth/data/models/login_response.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorage storage;
  final Dio dio;

  bool _isRefreshing = false;
  final List<Completer<void>> _refreshCompleters = [];

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
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    final requestOptions = err.requestOptions;

    if (requestOptions.extra['retry'] == true) {
      return handler.next(err);
    }

    try {
      await _refreshToken();

      final newAccessToken = storage.getAccessToken();
      requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
      requestOptions.extra['retry'] = true;

      final response = await dio.fetch(requestOptions);

      return handler.resolve(response);
    } catch (e) {
      await storage.deleteAllTokens();
      return handler.next(err);
    }
  }

  Future<void> _refreshToken() async {
    if (_isRefreshing) {
      final completer = Completer<void>();
      _refreshCompleters.add(completer);
      return completer.future;
    }

    _isRefreshing = true;

    try {
      final refreshToken = await storage.getRefreshToken();
      final response = await dio.post(
        "/auth/refresh-token",
        data: {"refreshToken": refreshToken},
      );

      final newAccessToken = response.data['accessToken'];
      final newRefreshToken = response.data['refreshToken'];

      await storage.saveToken(
        AuthToken(accessToken: newAccessToken, refreshToken: newRefreshToken),
      );

      for (final completer in _refreshCompleters) {
        completer.complete();
      }

      _refreshCompleters.clear();
    } catch (e) {
      for (final completer in _refreshCompleters) {
        completer.completeError(e);
      }

      _refreshCompleters.clear();
      rethrow;
    } finally {
      _isRefreshing = false;
    }
  }
}
