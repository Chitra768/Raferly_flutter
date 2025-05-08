class ModelApiResponse<T> {
  final int code;
  final bool status;
  final String message;
  final T? data;
  final List<dynamic> pagination;
  final String? error;

  ModelApiResponse({
    required this.code,
    required this.status,
    required this.message,
    this.data,
    required this.pagination,
    this.error,
  });

  factory ModelApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    return ModelApiResponse(
      code: json['code'] ?? 0,
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? fromJson(json['data']) : null,
      pagination: json['pagination'] ?? [],
      error: json['error'],
    );
  }

  bool get isSuccess => status && code == 200;
  bool get hasError => !status || error != null;
}
