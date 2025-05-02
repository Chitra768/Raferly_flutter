class ModelError {
  bool? status;
  String? message;
  Errors? errors;
  int? statusCode;

  ModelError({this.status, this.message, this.errors, this.statusCode});

  ModelError.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message']?.toString();
    errors = json['errors'] != null ? Errors.fromJson(json['errors']) : null;
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      if (errors != null) 'errors': errors!.toJson(),
      'statusCode': statusCode,
    };
  }
}

class Errors {
  Map<String, List<String>> errorMap = {};

  Errors({Map<String, List<String>>? errorMap}) {
    this.errorMap = errorMap ?? {};
  }

  Errors.fromJson(Map<String, dynamic> json) {
    json.forEach((key, value) {
      if (value is List) {
        errorMap[key] = List<String>.from(value.map((e) => e.toString()));
      }
    });
  }


  Map<String, dynamic> toJson() {
    return errorMap;
  }

  /// Get first error message from any field
  String? get firstError {
    if (errorMap.isEmpty) return null;
    for (var entry in errorMap.entries) {
      if (entry.value.isNotEmpty) {
        return entry.value.first;
      }
    }
    return null;
  }
}
