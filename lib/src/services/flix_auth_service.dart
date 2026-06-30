import 'dart:convert';
import 'dart:io';

import 'package:flix_inpage/flix_inpage.dart';

class FlixAuthService {
  FlixAuthService({HttpClient? httpClient})
    : _httpClient = httpClient ?? HttpClient();

  static const _prodAuthUrl =
      'https://api-syndication.flix360.io/prod/authenticate/token';
  static const _alphaAuthUrl =
      'https://api-syndication.flix360.io/alpha/authenticate/token';

  final HttpClient _httpClient;

  String? _username;
  bool? _useSandbox;
  String? _refreshToken;

  Future<FlixTokenResult> authenticate({
    required String username,
    required String password,
    required bool useSandbox,
  }) async {
    final response = await _requestToken(
      useSandbox: useSandbox,
      body: {'username': username, 'password': password},
      requireRefreshToken: true,
    );

    _username = username;
    _useSandbox = useSandbox;
    _refreshToken = response.refreshToken;

    return FlixTokenResult(idToken: response.idToken);
  }

  Future<FlixTokenResult> refreshToken() async {
    final username = _username;
    final useSandbox = _useSandbox;
    final refreshToken = _refreshToken;

    if (username == null || useSandbox == null || refreshToken == null) {
      throw const FlixAuthException('Missing token refresh context.');
    }

    final response = await _requestToken(
      useSandbox: useSandbox,
      body: {'username': username, 'refresh_token': refreshToken},
      requireRefreshToken: false,
    );

    _refreshToken = response.refreshToken ?? refreshToken;

    return FlixTokenResult(idToken: response.idToken);
  }

  Future<_AuthResponse> _requestToken({
    required bool useSandbox,
    required Map<String, String> body,
    required bool requireRefreshToken,
  }) async {
    final url = useSandbox ? _alphaAuthUrl : _prodAuthUrl;
    final request = await _httpClient.postUrl(Uri.parse(url));
    request.headers.contentType = ContentType.json;
    request.write(jsonEncode(body));

    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw FlixAuthException(
        'Authentication endpoint returned ${response.statusCode}.',
      );
    }

    final decoded = jsonDecode(responseBody);
    if (decoded is! Map<String, dynamic>) {
      throw const FlixAuthException('Authentication response is invalid.');
    }

    final idToken = decoded['id_token'];
    final refreshToken = decoded['refresh_token'];

    if (idToken is! String || idToken.trim().isEmpty) {
      throw const FlixAuthException('Authentication response has no id_token.');
    }

    if (requireRefreshToken &&
        (refreshToken is! String || refreshToken.trim().isEmpty)) {
      throw const FlixAuthException(
        'Authentication response has no refresh_token.',
      );
    }

    return _AuthResponse(
      idToken: idToken.trim(),
      refreshToken: refreshToken is String && refreshToken.trim().isNotEmpty
          ? refreshToken.trim()
          : null,
    );
  }
}

class FlixAuthException implements Exception {
  const FlixAuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

class _AuthResponse {
  const _AuthResponse({required this.idToken, required this.refreshToken});

  final String idToken;
  final String? refreshToken;
}
