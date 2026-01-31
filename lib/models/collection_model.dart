import 'package:uuid/uuid.dart';
import 'http_request.dart';

/// Modelo de coleção de requisições
class RequestCollection {
  final String id;
  String name;
  List<HttpRequest> requests;
  bool isExpanded;

  RequestCollection({
    String? id,
    required this.name,
    List<HttpRequest>? requests,
    this.isExpanded = true,
  }) : id = id ?? const Uuid().v4(),
       requests = requests ?? [];

  /// Adiciona uma requisição à coleção
  void addRequest(HttpRequest request) {
    requests.add(request);
  }

  /// Remove uma requisição da coleção
  void removeRequest(String requestId) {
    requests.removeWhere((r) => r.id == requestId);
  }

  /// Encontra uma requisição pelo ID
  HttpRequest? findRequest(String requestId) {
    try {
      return requests.firstWhere((r) => r.id == requestId);
    } catch (e) {
      return null;
    }
  }

  /// Cria uma cópia da coleção com campos modificados
  RequestCollection copyWith({
    String? name,
    List<HttpRequest>? requests,
    bool? isExpanded,
  }) {
    return RequestCollection(
      id: id,
      name: name ?? this.name,
      requests: requests ?? this.requests,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }

  /// Converte para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'requests': requests.map((r) => r.toJson()).toList(),
      'isExpanded': isExpanded,
    };
  }

  /// Cria a partir de JSON
  factory RequestCollection.fromJson(Map<String, dynamic> json) {
    return RequestCollection(
      id: json['id'] as String,
      name: json['name'] as String,
      requests: (json['requests'] as List)
          .map((r) => HttpRequest.fromJson(r as Map<String, dynamic>))
          .toList(),
      isExpanded: json['isExpanded'] as bool? ?? true,
    );
  }
}
