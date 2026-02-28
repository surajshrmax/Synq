import 'package:dio/dio.dart';
import 'package:synq/core/network/api_client.dart';
import 'package:synq/core/network/api_error.dart';
import 'package:synq/core/network/api_result.dart';

class DioApiClient implements ApiClient {
  final Dio dio;

  DioApiClient({required this.dio});

  @override
  Future<ApiResult<T>> delete<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) {
    return _request(
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
  }) {
    return _request(
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
  }) {
    return _request(
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
  Future<ApiResult<T>> patch<T>(String path, data) {
    return _request(() => dio.patch(path, data: data));
  }

  @override
  Future<ApiResult<T>> put<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(dynamic json)? mapper,
  }) {
    return _request(
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
      if (response.statusCode == 200) {
        return ApiSuccess<T>(
          data: fromJson != null ? fromJson(response.data) : response.data,
        );
      } else {
        return ApiFailure(
          error: ApiError(
            message: response.data['message'],
            errorType: ApiErrorType.unknown,
          ),
        );
      }
    } on DioException catch (e) {
      return ApiFailure(error: _mapDioError(e));
    } catch (e) {
      return ApiFailure(
        error: ApiError(message: e.toString(), errorType: ApiErrorType.unknown),
      );
    }
  }

  ApiError _mapDioError(DioException e) {
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

    final statusCode = e.response?.statusCode;

    if (statusCode == 401) {
      return ApiError(
        message: "Unauthorized",
        errorType: ApiErrorType.unauthorized,
        statusCode: statusCode,
      );
    }

    if (statusCode == 400) {
      return ApiError(
        message: e.response?.data["message"],
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
      message: 'Something went wrong',
      errorType: ApiErrorType.unknown,
      statusCode: statusCode,
    );
  }
}
