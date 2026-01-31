import 'package:flutter/material.dart';
import 'package:gk_http_client/models/http_request.dart';
import 'package:gk_http_client/models/http_response.dart';
import 'package:gk_http_client/models/collection_model.dart';
import 'package:gk_http_client/models/http_method.dart';
import 'package:gk_http_client/repository/collection_repository.dart';

/// Provider para gerenciar o estado das requisições
class RequestProvider with ChangeNotifier {
  final CollectionRepository _repository = CollectionRepository();

  // Coleções de requisições
  List<RequestCollection> _collections = [];

  // Requisição atualmente selecionada
  HttpRequest? _selectedRequest;

  // Resposta da última requisição
  HttpResponse? _currentResponse;

  // Loading state
  bool _isLoading = false;

  // Filtro de busca
  String _searchFilter = '';

  // Getters
  List<RequestCollection> get collections => _collections;
  HttpRequest? get selectedRequest => _selectedRequest;
  HttpResponse? get currentResponse => _currentResponse;
  bool get isLoading => _isLoading;
  String get searchFilter => _searchFilter;

  /// Adiciona uma nova coleção
  void addCollection(RequestCollection collection) {
    _collections.add(collection);
    _saveCollections(); // Auto-save
    notifyListeners();
  }

  /// Remove uma coleção
  void removeCollection(String collectionId) {
    _collections.removeWhere((c) => c.id == collectionId);
    _repository.delete(collectionId); // Remove do disco
    notifyListeners();
  }

  /// Atualiza uma coleção
  void updateCollection(RequestCollection collection) {
    final index = _collections.indexWhere((c) => c.id == collection.id);
    if (index != -1) {
      _collections[index] = collection;
      _saveCollections(); // Auto-save
      notifyListeners();
    }
  }

  /// Toggle expansão de uma coleção
  void toggleCollectionExpansion(String collectionId) {
    final index = _collections.indexWhere((c) => c.id == collectionId);
    if (index != -1) {
      _collections[index] = _collections[index].copyWith(
        isExpanded: !_collections[index].isExpanded,
      );
      notifyListeners();
    }
  }

  /// Adiciona uma requisição a uma coleção
  void addRequestToCollection(String collectionId, HttpRequest request) {
    final collection = _collections.firstWhere((c) => c.id == collectionId);
    collection.addRequest(request);
    _saveCollections(); // Auto-save
    notifyListeners();
  }

  /// Remove uma requisição de uma coleção
  void removeRequestFromCollection(String collectionId, String requestId) {
    final collection = _collections.firstWhere((c) => c.id == collectionId);
    collection.removeRequest(requestId);
    _saveCollections(); // Auto-save
    notifyListeners();
  }

  /// Seleciona uma requisição
  void selectRequest(HttpRequest? request) {
    _selectedRequest = request;
    _currentResponse = null; // Limpa a resposta anterior
    notifyListeners();
  }

  /// Atualiza a requisição selecionada
  void updateSelectedRequest(HttpRequest request) {
    if (_selectedRequest?.id == request.id) {
      _selectedRequest = request;

      // Atualiza também na coleção
      for (var collection in _collections) {
        final index = collection.requests.indexWhere((r) => r.id == request.id);
        if (index != -1) {
          collection.requests[index] = request;
          _saveCollections(); // Auto-save
          break;
        }
      }

      notifyListeners();
    }
  }

  /// Define a resposta atual
  void setCurrentResponse(HttpResponse? response) {
    _currentResponse = response;
    notifyListeners();
  }

  /// Define o estado de loading
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Define o filtro de busca
  void setSearchFilter(String filter) {
    _searchFilter = filter;
    notifyListeners();
  }

  /// Retorna as coleções filtradas pela busca
  List<RequestCollection> get filteredCollections {
    if (_searchFilter.isEmpty) {
      return _collections;
    }

    return _collections
        .map((collection) {
          final filteredRequests = collection.requests
              .where(
                (request) =>
                    request.name.toLowerCase().contains(
                      _searchFilter.toLowerCase(),
                    ) ||
                    request.url.toLowerCase().contains(
                      _searchFilter.toLowerCase(),
                    ),
              )
              .toList();

          if (filteredRequests.isEmpty) {
            return null;
          }

          return collection.copyWith(requests: filteredRequests);
        })
        .whereType<RequestCollection>()
        .toList();
  }

  /// Carrega dados de exemplo
  void loadMockData() {
    final collection1 = RequestCollection(
      name: 'User API v1',
      requests: [
        HttpRequest(
          name: 'Get All Users',
          method: HttpMethod.get,
          url: 'https://api.example.com/v1/users',
          queryParams: {'limit': '10', 'page': '1'},
        ),
        HttpRequest(
          name: 'Create Profile',
          method: HttpMethod.post,
          url: 'https://api.example.com/v1/users/profile',
        ),
        HttpRequest(
          name: 'Update Settings',
          method: HttpMethod.patch,
          url: 'https://api.example.com/v1/users/settings',
        ),
      ],
    );

    final collection2 = RequestCollection(
      name: 'Auth Service',
      requests: [
        HttpRequest(
          name: 'Login User',
          method: HttpMethod.post,
          url: 'https://api.example.com/auth/login',
        ),
      ],
    );

    _collections = [collection1, collection2];

    // Seleciona a primeira requisição por padrão
    if (_collections.isNotEmpty && _collections[0].requests.isNotEmpty) {
      _selectedRequest = _collections[0].requests[0];
    }

    // Salva dados mock
    _saveCollections();

    notifyListeners();
  }

  // ===== Métodos de Persistência =====

  /// Carrega coleções do repositório
  Future<void> loadCollections() async {
    try {
      _collections = await _repository.getAll();

      // Se não há coleções, carrega dados mock
      if (_collections.isEmpty) {
        loadMockData();
        return;
      }

      // Seleciona a primeira requisição por padrão
      if (_collections.isNotEmpty && _collections[0].requests.isNotEmpty) {
        _selectedRequest = _collections[0].requests[0];
      }

      notifyListeners();
    } catch (e) {
      // Em caso de erro, carrega dados mock
      loadMockData();
    }
  }

  /// Salva todas as coleções no repositório
  Future<void> _saveCollections() async {
    try {
      await _repository.saveAll(_collections);
    } catch (e) {
      // Log error silenciosamente
      debugPrint('Erro ao salvar coleções: $e');
    }
  }

  /// Exporta todas as coleções (sem assinatura)
  List<Map<String, dynamic>> exportCollections() {
    return _collections.map((c) => c.toJson()).toList();
  }

  /// Importa coleções de JSON
  Future<void> importCollections(List<Map<String, dynamic>> data) async {
    try {
      _collections = data
          .map((json) => RequestCollection.fromJson(json))
          .toList();

      await _saveCollections();
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao importar coleções: $e');
    }
  }
}
