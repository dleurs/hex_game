import 'package:hex_game/core/local_storage_manager.dart';
import 'package:hex_game/models/authentication/token.dart';

// Singleton state management
class AuthenticationManager {
  AuthenticationManager._privateConstructor();

  static final AuthenticationManager _instance = AuthenticationManager._privateConstructor();

  static AuthenticationManager get instance => _instance;

  static const String _AUTH_KEY = "hex_game.authentication";

  static const String EMAIL = "email";

  static const String PSEUDO = "pseudo";

  static const String PASSWORD = "password";

  static const String TOKEN = "token";

  static const String UID = "uid";

  static Future<bool> load() async {
    await _instance._load();
    return true;
  }

  final LocalStorageManager _storageManager = LocalStorageManager(_AUTH_KEY);

  bool get isLoggedIn => _uid != null;

  bool get isLoggedInEmail => (_uid != null && _email != null);

  String? _email;

  String? get email => _email;

  String? _pseudo;

  String? get pseudo => _pseudo;

  String? _password;

  String? get password => _password;

  Token? _token;

  Token? get token => _token;

  String? _uid;

  String? get uid => _uid;

  Future<void> _load() async {
    await _storageManager.open();
    _email = _storageManager.getString(EMAIL);
    _pseudo = _storageManager.getString(PSEUDO);
    //_password = await _storageManager.getSecureString(PASSWORD);
    _uid = _storageManager.getString(UID);
    var tokenJson = _storageManager.getJson(TOKEN);
    if (tokenJson != null) {
      //_token = Token.fromJson(tokenJson);
    }
  }

  Future<bool> userAlreadyOpenApp() async {
    await _storageManager.open();
    String USER_ALREADY_OPEN_APP = 'userAlreadyOpenApp';
    bool _userAlreadyOpenApp = (_storageManager.getBoolean(USER_ALREADY_OPEN_APP) ?? false);
    if (!_userAlreadyOpenApp) {
      print("User open the app for the first time");
      _storageManager.setBoolean(USER_ALREADY_OPEN_APP, true);
    } else {
      print("User already openned the app");
    }
    return (_userAlreadyOpenApp);
  }

  Future<void> doLogin(
      {required String email, required String password, String? pseudo, Token? token, required String userId}) async {
    _email = email;
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

  Future<void> updateCredentials({String? email, String? pseudo, String? password, Token? token, String? uid}) async {
    if (uid != null) {
      _uid = uid;
    }

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
    _email = null;
    _pseudo = null;
    _password = null;
    _token = null;
    _uid = null;
    await _save();
  }

  Future<void> _save() async {
    await _storageManager.open();
    await _storageManager.setString(EMAIL, _email);
    await _storageManager.setString(PSEUDO, _pseudo);
    //await _storageManager.setSecureString(PASSWORD, _password);
    await _storageManager.setString(UID, _uid);
    await _storageManager.setJson(TOKEN, _token);
  }

  Future<void> clear() async {
    await _storageManager.open();
    await _storageManager.clear();
  }

  String toString() {
    String str = "AuthenticationManager{\n";
    str += "_email:" + (_email ?? "null") + ",\n";
    str += "_pseudo:" + (_pseudo ?? "null") + ",\n";
    str += "_uid:" + (_uid ?? "null") + ",\n";
    str += "_token:" + (_token?.toShortString() ?? "null") + ",\n";
    str += "}";
    return str;
  }
}
