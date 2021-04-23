import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageManager {
  final String keyStorage;

  SharedPreferences? _prefs;
  // FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  // SecureStorage doesn't work on the web

  LocalStorageManager(this.keyStorage);

  Future<void> open() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    } else {
      await _prefs?.reload();
    }
    print("Existing keys for keyStorage $keyStorage : ${getKeys()}");
    //print("Existing secure keys for keyStorage $keyStorage : ${await getSecureKeys()}");
  }

  Future<bool> userAlreadyOpenApp() async {
    await open();
    String USER_ALREADY_OPEN_APP = 'userAlreadyOpenApp';
    bool _userAlreadyOpenApp = (getBoolean(USER_ALREADY_OPEN_APP) ?? false);
    if (!_userAlreadyOpenApp) {
      print("User open the app for the first time");
      setBoolean(USER_ALREADY_OPEN_APP, true);
    } else {
      print("User already openned the app");
    }
    return (_userAlreadyOpenApp);
  }

/*   Future<String?> getSecureString(String key) async {
    return _secureStorage.read(key: _buildKey(key));
  } */

/*   Future<void> setSecureString(String key, String? value) async {
    String finalKey = _buildKey(key);
    if (value == null) {
      await _secureStorage.delete(key: finalKey);
    } else {
      await _secureStorage.write(key: finalKey, value: value);
    }
  } */

  void _checkPrefs() {
    if (_prefs == null) {
      print("You need to call open() before accessing preferences for storage with key $keyStorage");
      throw Exception("You need to call open() before accessing preferences for storage with key $keyStorage");
    }
  }

  String? getString(String key) {
    _checkPrefs();
    return _prefs?.getString(_buildKey(key));
  }

  bool? getBoolean(String key) {
    return _prefs?.getBool(_buildKey(key));
  }

  double? getDouble(String key) {
    _checkPrefs();
    return _prefs?.getDouble(_buildKey(key));
  }

  int? getInt(String key) {
    _checkPrefs();
    return _prefs?.getInt(_buildKey(key));
  }

  List<String>? getStringList(String key, {List<String>? defaultValue}) {
    _checkPrefs();
    return _prefs?.getStringList(_buildKey(key)) ?? defaultValue;
  }

  Map<String, dynamic>? getJson(String key) {
    _checkPrefs();
    String? source = _prefs?.getString(_buildKey(key));
    if (source != null && source.isNotEmpty) {
      return jsonDecode(source);
    }
    return null;
  }

  Future<void> setString(String key, String? value) async {
    _checkPrefs();
    if (value != null) {
      await _prefs?.setString(_buildKey(key), value);
    }
  }

  Future<void> setBoolean(String key, bool? value) async {
    _checkPrefs();
    if (value != null) {
      await _prefs?.setBool(_buildKey(key), value);
    }
  }

  Future<void> setDouble(String key, double? value) async {
    _checkPrefs();
    if (value != null) {
      await _prefs?.setDouble(_buildKey(key), value);
    }
  }

  Future<void> setInt(String key, int? value) async {
    _checkPrefs();
    if (value != null) {
      await _prefs?.setInt(_buildKey(key), value);
    }
  }

  Future<void> setStringList(String key, List<String>? value) async {
    _checkPrefs();
    if (value != null) {
      await _prefs?.setStringList(_buildKey(key), value);
    }
  }

  Future<void> setJson<T>(String key, T? value) async {
    _checkPrefs();
    String json;
    if (value != null) {
      json = jsonEncode(value);
      await _prefs?.setString(_buildKey(key), json);
    } else {
      await _prefs?.remove(_buildKey(key));
    }
  }

  Future<void> remove(String key) async {
    _checkPrefs();
    String finalKey = _buildKey(key);
    await _prefs?.remove(finalKey);
    //await _secureStorage.delete(key: finalKey);
  }

  Future<void> clear() async {
    for (var key in getKeys()) {
      await _prefs?.remove(key);
    }

/*     var secureKeys = await getSecureKeys();
    for (var key in secureKeys) {
      await _secureStorage.delete(key: key);
    } */
  }

  bool containsKey(String key) {
    _checkPrefs();
    return _prefs?.containsKey(_buildKey(key)) ?? false;
  }

  Set<String> getKeys() {
    _checkPrefs();
    Set<String> keys = Set();
    for (var key in _prefs?.getKeys() ?? Set<String>()) {
      if (key.startsWith(this.keyStorage)) {
        keys.add(key);
      }
    }
    return keys;
  }

/*   Future<Set<String>> getSecureKeys() async {
    var allSecure = await _secureStorage.readAll();
    Set<String> keys = Set();
    for (var key in allSecure.keys) {
      if (key.startsWith(this.keyStorage)) {
        keys.add(key);
      }
    }
    return keys;
  } */

  String _buildKey(String key) {
    //return "$keyStorage${Config.appFlavor}.$key";
    return "$keyStorage.$key";
  }
}
