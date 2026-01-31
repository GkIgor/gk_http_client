import 'package:uuid/uuid.dart';
import 'http_method.dart';

/// Modelo de requisição HTTP
class HttpRequest {
  final String id;
  String name;
  HttpMethod method;
  String url;
  Map<String, String> queryParams;
  Map<String, String> headers;
  String? body;
  // TODO: Adicionar AuthConfig quando implementado
  // AuthConfig? auth;

  HttpRequest({
    String? id,
    required this.name,
    required this.method,
    required this.url,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
    this.body,
  }) : id = id ?? const Uuid().v4(),
       queryParams = queryParams ?? {},
       headers = headers ?? {};

  /// Cria uma cópia da requisição com campos modificados
  HttpRequest copyWith({
    String? name,
    HttpMethod? method,
    String? url,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
    String? body,
  }) {
    return HttpRequest(
      id: id,
      name: name ?? this.name,
      method: method ?? this.method,
      url: url ?? this.url,
      queryParams: queryParams ?? this.queryParams,
      headers: headers ?? this.headers,
      body: body ?? this.body,
    );
  }

  /// Converte para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'method': method.value,
      'url': url,
      'queryParams': queryParams,
      'headers': headers,
      'body': body,
    };
  }

  /// Cria a partir de JSON
  factory HttpRequest.fromJson(Map<String, dynamic> json) {
    return HttpRequest(
      id: json['id'] as String,
      name: json['name'] as String,
      method: HttpMethod.values.firstWhere(
        (m) => m.value == json['method'],
        orElse: () => HttpMethod.get,
      ),
      url: json['url'] as String,
      queryParams: Map<String, String>.from(json['queryParams'] ?? {}),
      headers: Map<String, String>.from(json['headers'] ?? {}),
      body: json['body'] as String?,
    );
  }
}
