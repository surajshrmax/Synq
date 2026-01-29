import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:synq/features/auth/data/models/login_response.dart';

class SecureStorage {
  static const _id = "id";
  static const _accessTokenKey = "access_token";
  static const _refreshTokenkey = "refresh_token";

  final FlutterSecureStorage _storage;

  SecureStorage(this._storage);

  Future<void> saveToken(AuthToken token) async {
    await _storage.write(key: _accessTokenKey, value: token.accessToken);
    await _storage.write(key: _refreshTokenkey, value: token.refreshTokne);
  }

  Future<String?> getId() async {
    return await _storage.read(key: _id);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenkey);
  }

  Future<void> deleteAllTokens() async {
    await _storage.deleteAll();
  }
}
