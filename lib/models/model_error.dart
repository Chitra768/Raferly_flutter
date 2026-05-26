class ModelError {
  bool? status;
  String? message;
  Errors? errors;
  /// BE sometimes returns a string error code (e.g. `agency_colleague_access_denied`).
  String? errorCode;
  int? statusCode;

  ModelError({
    this.status,
    this.message,
    this.errors,
    this.errorCode,
    this.statusCode,
  });

  ModelError.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message']?.toString();
    final rawErrors = json['errors'];
    if (rawErrors is Map) {
      errors = Errors.fromJson(Map<String, dynamic>.from(rawErrors));
    } else if (rawErrors is String && rawErrors.isNotEmpty) {
      errorCode = rawErrors;
      errors = Errors(errorMap: {'errors': [rawErrors]});
    }
    statusCode = json['statusCode'] ?? json['code']; // Support for 'code' as fallback
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
      } else if (value is String) {
        errorMap[key] = [value];
      }
    });
  }

  Map<String, dynamic> toJson() => errorMap;

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
