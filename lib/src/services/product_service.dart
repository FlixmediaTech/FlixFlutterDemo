import 'dart:convert';
import 'dart:io';

import '../models/remote_product.dart';

class ProductService {
  ProductService({HttpClient? client}) : _client = client ?? HttpClient();

  final HttpClient _client;

  Future<List<RemoteProduct>> fetchProducts() async {
    final uri = Uri.parse(
      'https://demo.flix360.io/mobile-api/supporting/home-product-list.json',
    );

    final request = await _client.getUrl(uri);
    request.headers.set(HttpHeaders.acceptHeader, 'application/json');
    final response = await request.close();

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw HttpException(
        'Invalid response status: ${response.statusCode}',
        uri: uri,
      );
    }

    final body = await utf8.decoder.bind(response).join();
    final dynamic decoded = jsonDecode(body);
    if (decoded is! List) {
      throw const FormatException('Invalid response payload');
    }

    return decoded
        .whereType<Map<String, dynamic>>()
        .map(RemoteProduct.fromJson)
        .toList(growable: false);
  }
}
