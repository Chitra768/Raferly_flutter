import '../models/model_error.dart';

abstract class ApiResult {}

class ApiSuccess<T> extends ApiResult {
  final T data;
  ApiSuccess(this.data);
}

class ApiFailure extends ApiResult {
  final ModelError error;
  ApiFailure(this.error);
}