import 'package:hex_game/core/local_storage_manager.dart';
import 'package:hex_game/models/authentication/token.dart';

class AuthenticationManager {
  AuthenticationManager._privateConstructor();

  static final AuthenticationManager _instance = AuthenticationManager._privateConstructor();

  static AuthenticationManager get instance => _instance;

  static const String _AUTH_KEY = "hex_game.authentication";

  static const String IS_LOGGED_IN = "isLoggedIn";

  static const String EMAIL = "email";

  static const String PSEUDO = "pseudo";

  static const String PASSWORD = "password";

  static const String TOKEN = "token";

  static const String USER_ID = "uid";

  static Future<void> load() async {
    await _instance._load();
  }

  final LocalStorageManager _storageManager = LocalStorageManager(_AUTH_KEY);

  bool? _isLoggedIn;

  bool get isLoggedIn => _isLoggedIn ?? false;

  String? _email;

  String? get login => _email;

  String? _pseudo;

  String? get pseudo => _pseudo;

  String? _password;

  String? get password => _password;

  Token? _token;

  Token? get token => _token;

  String? _uid;

  String? get userId => _uid;

  Future<void> _load() async {
    await _storageManager.open();
    _isLoggedIn = _storageManager.getBoolean(IS_LOGGED_IN) ?? false;
    _email = _storageManager.getString(EMAIL);
    _pseudo = _storageManager.getString(PSEUDO);
    _password = await _storageManager.getSecureString(PASSWORD);
    _uid = _storageManager.getString(USER_ID);
    var tokenJson = _storageManager.getJson(TOKEN);
    if (tokenJson != null) {
      //_token = Token.fromJson(tokenJson);
    }
  }

  Future<void> doLogin(
      {required String login, required String password, String? pseudo, Token? token, required String userId}) async {
    _isLoggedIn = true;
    _email = login;
    _pseudo = pseudo;
    _password = password;
    _token = token;
    _uid = userId;
    await _save();
  }

  Future<void> saveUserId(String userId) async {
    _uid = userId;
    await _save();
  }

  Future<void> updateCredentials(
      {String? email, String? pseudo, String? password, Token? token, String? userId}) async {
    if (email != null) {
      _email = email;
    }

    if (pseudo != null) {
      _pseudo = pseudo;
    }

    if (password != null) {
      _password = password;
    }

    if (token != null) {
      _token = token;
    }

    await _save();
  }

  Future<void> doLogout() async {
    _isLoggedIn = false;
    _email = null;
    _pseudo = null;
    _password = null;
    _token = null;
    _uid = null;
    await _save();
  }

  Future<void> _save() async {
    await _storageManager.open();
    await _storageManager.setSecureString(EMAIL, _email);
    await _storageManager.setSecureString(PSEUDO, _pseudo);
    await _storageManager.setSecureString(PASSWORD, _password);
    await _storageManager.setBoolean(IS_LOGGED_IN, _isLoggedIn);
    await _storageManager.setString(USER_ID, _uid);
    await _storageManager.setJson(TOKEN, _token);
  }

  Future<void> clear() async {
    await _storageManager.open();
    await _storageManager.clear();
  }

  String toString() {
    String str = "AuthenticationManager{";
    str += "_isLoggedIn:" + _isLoggedIn.toString() + ", ";
    str += "_email:" + (_email ?? "null") + ", ";
    str += "_pseudo:" + (_pseudo ?? "null") + ", ";
    str += "_token:" + (_token?.toShortString() ?? "null") + ", ";
    str += "_userId:" + (_uid ?? "null");
    str += "}";
    return str;
  }
}
