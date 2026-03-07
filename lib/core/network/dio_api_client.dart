import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logging/logging.dart';
import 'package:synq/core/network/api_client.dart';
import 'package:synq/core/network/api_error.dart';
import 'package:synq/core/network/api_result.dart';
import 'package:synq/features/auth/data/models/login_response.dart';

class DioApiClient implements ApiClient {
  final Dio dio;

  DioApiClient({required this.dio});

  @override
  Future<ApiResult<T>> delete<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    return await _request(
      () => dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      ),
    );
  }

  @override
  Future<ApiResult<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(dynamic json)? mapper,
  }) async {
    return await _request(
      () => dio.request(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      ),
      fromJson: mapper,
    );
  }

  @override
  Future<ApiResult<T>> post<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(dynamic json)? mapper,
  }) async {
    return await _request(
      () => dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      ),
      fromJson: mapper,
    );
  }

  @override
  Future<ApiResult<T>> patch<T>(String path, data) async {
    return await _request(() => dio.patch(path, data: data));
  }

  @override
  Future<ApiResult<T>> put<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(dynamic json)? mapper,
  }) async {
    return await _request(
      () => dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      ),
      fromJson: mapper,
    );
  }

  Future<ApiResult<T>> _request<T>(
    Future<Response> Function() request, {
    T Function(dynamic json)? fromJson,
  }) async {
    try {
      final response = await request();
      final statusCode = response.statusCode!;
      if (statusCode == 200) {
        return ApiSuccess<T>(
          data: fromJson != null ? fromJson(response.data) : response.data,
        );
      } else {
        return ApiFailure<T>(error: _onError(statusCode, response));
      }
    } on DioException catch (e) {
      return ApiFailure<T>(error: _onDioException(e));
    } catch (e) {
      return ApiFailure<T>(
        error: ApiError(
          message: "Something went wrong!",
          errorType: ApiErrorType.unknown,
        ),
      );
    }
  }

  ApiError _onDioException(DioException e) {
    if (e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionTimeout) {
      return const ApiError(
        message: "Connection timeout",
        errorType: ApiErrorType.timeout,
      );
    }

    if (e.type == DioExceptionType.connectionError) {
      return const ApiError(
        message: "No internet connection",
        errorType: ApiErrorType.network,
      );
    }

    return ApiError(
      message: 'Something went wrong!',
      errorType: ApiErrorType.unknown,
    );
  }

  ApiError _onError(int statusCode, Response response) {
    if (statusCode == 401) {
      return ApiError(
        message: "Unauthorized",
        errorType: ApiErrorType.unauthorized,
        statusCode: statusCode,
      );
    }

    if (statusCode == 400) {
      return ApiError(
        message: response.data['message'],
        errorType: ApiErrorType.user,
      );
    }

    if (statusCode == 500) {
      return ApiError(
        message: "Internal server error",
        errorType: ApiErrorType.server,
        statusCode: statusCode,
      );
    }

    return ApiError(
      message: 'Something went wrong!',
      errorType: ApiErrorType.unknown,
    );
  }
}
