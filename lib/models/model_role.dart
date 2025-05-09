class ModelRole {
  final int id;
  final String name;
  final String guardName;
  final String createdAt;
  final String updatedAt;
  final RolePivot pivot;

  ModelRole({
    required this.id,
    required this.name,
    required this.guardName,
    required this.createdAt,
    required this.updatedAt,
    required this.pivot,
  });

  factory ModelRole.fromJson(Map<String, dynamic> json) {
    return ModelRole(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      guardName: json['guard_name'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      pivot: RolePivot.fromJson(json['pivot'] ?? {}),
    );
  }
}

class RolePivot {
  final String modelType;
  final int modelId;
  final int roleId;

  RolePivot({
    required this.modelType,
    required this.modelId,
    required this.roleId,
  });

  factory RolePivot.fromJson(Map<String, dynamic> json) {
    return RolePivot(
      modelType: json['model_type'] ?? '',
      modelId: json['model_id'] ?? 0,
      roleId: json['role_id'] ?? 0,
    );
  }
}
