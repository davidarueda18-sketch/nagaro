import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract interface class SecureStorageService {
  Future<void> writeToken(String token);
  Future<String?> readToken();
  Future<void> deleteToken();
  Future<void> write(String key, String value);
  Future<String?> read(String key);
  Future<void> delete(String key);
  Future<void> deleteAll();
}

class SecureStorageServiceImpl implements SecureStorageService {
  SecureStorageServiceImpl() : _storage = const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
      );

  final FlutterSecureStorage _storage;

  static const _tokenKey = 'auth_token';

  @override
  Future<void> writeToken(String token) => _storage.write(key: _tokenKey, value: token);

  @override
  Future<String?> readToken() => _storage.read(key: _tokenKey);

  @override
  Future<void> deleteToken() => _storage.delete(key: _tokenKey);

  @override
  Future<void> write(String key, String value) => _storage.write(key: key, value: value);

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);

  @override
  Future<void> deleteAll() => _storage.deleteAll();
}
