import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Хранилище токенов
class TokenStorage {
  final _storage = const FlutterSecureStorage(
    webOptions: WebOptions(
      dbName: 'PlaceSeeSecureStorage',
      publicKey: 'place_see_app_key',
      useSessionStorage: true
    )
  );

  Future<void> saveTokens({required String accessToken, required String refreshToken,}) async{
    await _storage.write(key: "access_token", value: accessToken);
    await _storage.write(key: "refresh_token", value: refreshToken);
  }

  Future<String?> getAccessToken() => _storage.read(key: "access_token");
  Future<String?> getRefreshToken() => _storage.read(key: "refresh_token");
  Future<void> clear() async => await _storage.deleteAll();
}