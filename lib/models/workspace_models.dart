class WorkspaceModel {
  final String id;
  String name;
  Map<String, WorkspaceSecretKey> environments = {};

  WorkspaceModel({
    required this.name,
    String? id,
    Map<String, WorkspaceSecretKey>? environments,
  }) : id = id ?? "ws_${DateTime.now().microsecondsSinceEpoch}",
       environments = environments ?? {};

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      // Aqui convertemos o Map de segredos também
      'environments': environments.map((k, v) => MapEntry(k, v.toMap())),
    };
  }
}

class WorkspaceSecretKey {
  String value;
  bool isSecret;

  WorkspaceSecretKey({required this.value, this.isSecret = false});

  Map<String, dynamic> toMap() => {'value': value, 'isSecret': isSecret};
}
