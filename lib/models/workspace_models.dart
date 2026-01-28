enum WorkspaceItemType { folder, request }

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
      'environments': environments.map((k, v) => MapEntry(k, v.toMap())),
    };
  }

  factory WorkspaceModel.fromMap(Map<String, dynamic> map) {
    final dynamic envMap = map['environments'];

    Map<String, WorkspaceSecretKey> loadedEnvs = {};

    if (envMap != null && envMap is Map) {
      envMap.forEach((key, value) {
        loadedEnvs[key] = WorkspaceSecretKey.fromMap(
          Map<String, dynamic>.from(value),
        );
      });
    }

    return WorkspaceModel(
      name: map['name'],
      id: map['id'],
      environments: loadedEnvs,
    );
  }
}

class WorkspaceSecretKey {
  late String value;
  late bool isSecret;

  WorkspaceSecretKey({required this.value, this.isSecret = false});

  WorkspaceSecretKey.fromMap(Map<String, dynamic> map) {
    value = map['value'];
    isSecret = map['isSecret'] ?? false;
  }

  Map<String, dynamic> toMap() => {'value': value, 'isSecret': isSecret};
}

class WorkspaceItem {
  final String id;
  String name;
  final WorkspaceItemType type;
  final List<WorkspaceItem> children;

  WorkspaceItem({
    required this.id,
    required this.name,
    required this.type,
    this.children = const [],
  });

  //TO-DO WorkspaceItem.fromMap

  //TO-DO toMap
}
