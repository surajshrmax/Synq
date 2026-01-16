import 'package:synq/core/network/api_error.dart';

sealed class ApiResult<T> {
  const ApiResult();

  R when<R>({
    required R Function(T data) success,
    required R Function(ApiError error) failure,
  });
}

class ApiSuccess<T> extends ApiResult<T> {
  final T data;

  ApiSuccess({required this.data});

  @override
  when<R>({
    required Function(T data) success,
    required Function(ApiError error) failure,
  }) {
    return success(data);
  }
}

class ApiFailure<T> extends ApiResult<T> {
  final ApiError error;

  ApiFailure({required this.error});

  @override
  when<R>({
    required Function(T data) success,
    required Function(ApiError error) failure,
  }) {
    return failure(error);
  }
}
