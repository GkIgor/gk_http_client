import 'dart:convert';
import 'dart:io';
import 'package:gk_http_client/core/app_config.dart';
import 'package:gk_http_client/models/collection_model.dart';
import 'package:gk_http_client/utils/utils.dart';

/// Repositório para persistência de coleções de requisições
/// Utiliza o mesmo padrão de segurança do WorkspaceRepository
class CollectionRepository {
  final String _path = AppConfig.collectionsDir;

  /// Carrega todas as coleções do disco
  /// Valida assinatura de segurança usando SecurityUtils
  Future<List<RequestCollection>> getAll() async {
    final dir = Directory(_path);

    if (!dir.existsSync()) {
      return [];
    }

    final files = dir.listSync().where((f) => f.path.endsWith('.json'));
    final List<RequestCollection> collections = [];

    for (var entity in files) {
      final file = File(entity.path);

      // Segurança: Ignora arquivos muito grandes (>10MB)
      if (file.statSync().size > 10 * 1024 * 1024) continue;

      try {
        final content = file.readAsStringSync();
        final Map<String, dynamic> map = jsonDecode(content);
        final String? fileSignature = map['signature'];

        // Remove assinatura para validação
        final dataToValidate = Map<String, dynamic>.from(map)
          ..remove('signature');

        // Gera hash dinâmico baseado em user@host#size
        final String currentHash = SecurityUtils.generateDynamicHash(
          jsonEncode(dataToValidate),
        );

        // Segurança: Ignora arquivos com assinatura inválida
        if (fileSignature != currentHash) continue;

        collections.add(RequestCollection.fromJson(map));
      } catch (error) {
        // Ignora arquivos corrompidos
        continue;
      }
    }

    return collections;
  }

  /// Salva uma coleção no disco com assinatura de segurança
  Future<void> save(RequestCollection collection) async {
    final Map<String, dynamic> map = collection.toJson();
    map.remove('signature');

    final String rawJson = jsonEncode(map);
    final String signature = SecurityUtils.generateDynamicHash(rawJson);

    map['signature'] = signature;

    final file = File('$_path/${collection.id}.json');
    await file.writeAsString(jsonEncode(map));
  }

  /// Salva múltiplas coleções
  Future<void> saveAll(List<RequestCollection> collections) async {
    for (var collection in collections) {
      await save(collection);
    }
  }

  /// Deleta uma coleção pelo ID
  Future<void> delete(String collectionId) async {
    final file = File('$_path/$collectionId.json');
    if (file.existsSync()) {
      await file.delete();
    }
  }

  /// Deleta todas as coleções
  Future<void> deleteAll() async {
    final dir = Directory(_path);
    if (dir.existsSync()) {
      final files = dir.listSync().where((f) => f.path.endsWith('.json'));
      for (var file in files) {
        await file.delete();
      }
    }
  }

  /// Carrega uma coleção específica pelo ID
  Future<RequestCollection?> getById(String collectionId) async {
    final file = File('$_path/$collectionId.json');

    if (!file.existsSync()) {
      return null;
    }

    try {
      final content = file.readAsStringSync();
      final Map<String, dynamic> map = jsonDecode(content);
      final String? fileSignature = map['signature'];

      final dataToValidate = Map<String, dynamic>.from(map)
        ..remove('signature');

      final String currentHash = SecurityUtils.generateDynamicHash(
        jsonEncode(dataToValidate),
      );

      // Verifica assinatura
      if (fileSignature != currentHash) {
        return null;
      }

      return RequestCollection.fromJson(map);
    } catch (error) {
      return null;
    }
  }
}
