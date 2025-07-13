import 'package:builders_konnect/core/core.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  static Box<dynamic> get _generalBox =>
      Hive.box<dynamic>(StorageKey.generalHiveBox);

  static Future<void> storeAccessToken(String token) async {
    try {
      await _generalBox.put(StorageKey.accessToken, token);
    } catch (e) {
      printty(e.toString(), logName: 'StorageService storeAccessToken');
    }
  }

  static Future<String?> getAccessToken() async {
    if (_generalBox.containsKey(StorageKey.accessToken) &&
        _generalBox.get(StorageKey.accessToken) != null) {
      return _generalBox.get(StorageKey.accessToken);
    }
    return null;
  }

  static Future<void> storeRefreshToken(String token) async {
    try {
      await _generalBox.put(StorageKey.refreshToken, token);
    } catch (e) {
      printty(e.toString(), logName: 'StorageService storeRefreshToken');
    }
  }

  static Future<String?> getRefreshToken() async {
    if (_generalBox.containsKey(StorageKey.refreshToken) &&
        _generalBox.get(StorageKey.refreshToken) != null) {
      return _generalBox.get(StorageKey.refreshToken);
    }
    return null;
  }

  static Future<void> removeAccessToken() async {
    if (_generalBox.containsKey(StorageKey.accessToken)) {
      return _generalBox.delete(StorageKey.accessToken);
    }
  }

  static Future<void> removeRefreshToken() async {
    if (_generalBox.containsKey(StorageKey.refreshToken)) {
      return _generalBox.delete(StorageKey.refreshToken);
    }
  }

  // static Future<AuthUserModel?> getUser() async {
  //   if (_generalBox.containsKey(StorageKey.authUser) &&
  //       _generalBox.get(StorageKey.authUser) != null) {
  //     return AuthUserModel.fromJson(
  //         json.decode(_generalBox.get(StorageKey.authUser)!));
  //   }
  //   return null;
  // }

  // static Future<void> storeUser(AuthUserModel user) async {
  //   try {
  //     await _generalBox.put(StorageKey.authUser, json.encode(user.toJson()));
  //   } catch (e) {
  //     printty(e.toString(), logName: 'StorageService storeUser');
  //   }
  // }

  static Future<void> removeUser() async {
    if (_generalBox.containsKey(StorageKey.authUser)) {
      return _generalBox.delete(StorageKey.authUser);
    }
  }

  static Future<void> logout() async {
    await removeAccessToken();
    await removeRefreshToken();
    await removeUser();
  }

  static Future<bool> storeBoolItem(String key, bool value) async {
    try {
      await _generalBox.put(key, value);
      return true;
    } catch (e) {
      printty(e.toString(), logName: 'StorageService storeBoolItem');
      return false;
    }
  }

  static Future<bool?> getBoolItem(String key) async {
    if (_generalBox.containsKey(key) && _generalBox.get(key) != null) {
      return _generalBox.get(key);
    }
    return null;
  }

  static Future<void> storeStringItem(String key, String value) async {
    try {
      await _generalBox.put(key, value);
    } catch (e) {
      printty(e.toString(), logName: 'StorageService storeStringItem');
    }
  }

  static Future<String?> getStringItem(String key) async {
    if (_generalBox.containsKey(key) && _generalBox.get(key) != null) {
      return _generalBox.get(key);
    }
    return null;
  }

  static Future<void> removeItem(String key) async {
    if (_generalBox.containsKey(key)) {
      return _generalBox.delete(key);
    }
  }
}
