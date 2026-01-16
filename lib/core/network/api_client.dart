import 'package:synq/core/network/api_result.dart';

abstract class ApiClient {
  Future<ApiResult<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(dynamic json)? mapper
  });

  Future<ApiResult<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(dynamic json)? mapper,
  });

  Future<ApiResult<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(dynamic json)? mapper
  });

  Future<ApiResult<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });
}
