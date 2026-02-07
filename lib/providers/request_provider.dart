import 'package:flutter/material.dart';
import 'package:gk_http_client/models/http_request.dart';
import 'package:gk_http_client/models/http_response.dart';
import 'package:gk_http_client/models/collection_model.dart';

import 'package:gk_http_client/repository/collection_repository.dart';

class RequestProvider with ChangeNotifier {
  final CollectionRepository _repository = CollectionRepository();

  List<RequestCollection> _collections = [];

  HttpRequest? _selectedRequest;

  HttpResponse? _currentResponse;

  bool _isLoading = false;

  String _searchFilter = '';

  List<RequestCollection> get collections => _collections;
  HttpRequest? get selectedRequest => _selectedRequest;
  HttpResponse? get currentResponse => _currentResponse;
  bool get isLoading => _isLoading;
  String get searchFilter => _searchFilter;

  void addCollection(RequestCollection collection) {
    _collections.add(collection);
    _saveCollections();
    notifyListeners();
  }

  void removeCollection(String collectionId) {
    _collections.removeWhere((c) => c.id == collectionId);
    _repository.delete(collectionId);
    notifyListeners();
  }

  void updateCollection(RequestCollection collection) {
    final index = _collections.indexWhere((c) => c.id == collection.id);
    if (index != -1) {
      _collections[index] = collection;
      _saveCollections();
      notifyListeners();
    }
  }

  void toggleCollectionExpansion(String collectionId) {
    final index = _collections.indexWhere((c) => c.id == collectionId);
    if (index != -1) {
      _collections[index] = _collections[index].copyWith(
        isExpanded: !_collections[index].isExpanded,
      );
      notifyListeners();
    }
  }

  void addRequestToCollection(String collectionId, HttpRequest request) {
    final collection = _collections.firstWhere((c) => c.id == collectionId);
    collection.addRequest(request);
    _saveCollections();
    notifyListeners();
  }

  void removeRequestFromCollection(String collectionId, String requestId) {
    final collection = _collections.firstWhere((c) => c.id == collectionId);
    collection.removeRequest(requestId);
    _saveCollections();
    notifyListeners();
  }

  void selectRequest(HttpRequest? request) {
    _selectedRequest = request;
    _currentResponse = null;
    notifyListeners();
  }

  void updateSelectedRequest(HttpRequest request) {
    if (_selectedRequest?.id == request.id) {
      _selectedRequest = request;

      for (var collection in _collections) {
        final index = collection.requests.indexWhere((r) => r.id == request.id);
        if (index != -1) {
          collection.requests[index] = request;
          _saveCollections();
          break;
        }
      }

      notifyListeners();
    }
  }

  void setCurrentResponse(HttpResponse? response) {
    _currentResponse = response;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setSearchFilter(String filter) {
    _searchFilter = filter;
    notifyListeners();
  }

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

  Future<void> loadCollections(String workspaceId) async {
    _collections = await _repository.getAll(workspaceId);

    if (_collections.isNotEmpty && _collections[0].requests.isNotEmpty) {
      _selectedRequest = _collections[0].requests[0];
    }

    notifyListeners();
  }

  Future<void> _saveCollections() async {
    try {
      await _repository.saveAll(_collections);
    } catch (e) {
      debugPrint('Erro ao salvar coleções: $e');
    }
  }

  List<Map<String, dynamic>> exportCollections() {
    return _collections.map((c) => c.toJson()).toList();
  }

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
