import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hex_game/core/authentication/authentication_api_manager.dart';
import 'package:hex_game/core/local_storage_manager.dart';
import 'package:hex_game/models/authentication/token.dart';
import 'package:hex_game/models/player.dart';
import 'package:hex_game/utils/exceptions.dart';

import './bloc.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationApiProvider _provider;

  static const String _AUTH_KEY = "hex_game.authentication";
  static const String EMAIL = "email";
  static const String PSEUDO = "pseudo";
  static const String PASSWORD = "password";
  static const String TOKEN = "token";
  static const String UID = "uid";

  bool get isLoggedIn => _uid != null;
  String? _email;
  String? get email => _email;
  String? _pseudo;
  String? get pseudo => _pseudo;
  //String? _password;
  //String? get password => _password;
  Token? _token;
  Token? get token => _token;
  String? _uid;
  String? get uid => _uid;
  final LocalStorageManager _storageManager = LocalStorageManager(_AUTH_KEY);

  Future<void> load() async {
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
    const String USER_ALREADY_OPEN_APP = 'userAlreadyOpenApp';
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
    //_password = password;
    _token = token;
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
    // if (password != null) {
    //   _password = password;
    // }
    if (token != null) {
      _token = token;
    }
    await _save();
  }

  Future<void> doLogout() async {
    _email = null;
    _pseudo = null;
    //_password = null;
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
    String str = "AuthenticationBloc{\n";
    str += "state:" + state.toString() + ",\n";
    str += "_email:" + (_email ?? "null") + ",\n";
    str += "_pseudo:" + (_pseudo ?? "null") + ",\n";
    str +=
        "_uid:" + ((_uid == null) ? "null" : _uid!.substring(0, 3) + "..." + _uid!.substring(_uid!.length - 3)) + ",\n";
    str += "_token:" + (_token?.toShortString() ?? "null") + ",\n";
    str += "}";
    return str;
  }

  AuthenticationBloc(this._provider) : super(InitialAuthenticationState());

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    yield AuthenticationProcessing();

    if (event is SynchroniseAuthentication) {
      try {
        //await AuthenticationManager.load();
        User? fireUser = _provider.dbAuth.currentUser;
        if (fireUser == null || fireUser.uid.isEmpty) {
          await doLogout();
        } else {
          updateCredentials(email: fireUser.email, uid: fireUser.uid);
        }
        if (pseudo == null && fireUser != null && fireUser.uid.isNotEmpty) {
          Player? player = await _provider.getPlayer(uid: fireUser.uid);
          updateCredentials(pseudo: player!.pseudo);
        }
      } catch (e) {}
      yield AuthenticationSuccessNoRedirect();
    }
    if (event is RegisterEvent) {
      try {
        bool pseudoAlreadyUsed = await _provider.isPseudoAlreadyUsed(pseudo: event.pseudo);
        if (pseudoAlreadyUsed) {
          throw PseudoAlredyUsedException();
        }
        User? user = await _provider.register(email: event.email.toLowerCase(), password: event.password);
        user!;
        await doLogin(
            email: event.email,
            pseudo: event.pseudo,
            password: event.password,
            //token: token,
            userId: user.uid);
        Player player = Player(uid: user.uid, pseudo: event.pseudo);
        await _provider.updatePlayer(player: player, operation: SaveFirestoreOperation.emailRegister);
        yield AuthenticationSuccess();
      } on FirebaseAuthException catch (e) {
        if (e.code == "email-already-in-use") {
          yield RegisterErrorEmailAlreadyUsed();
        } else if (e.code == "invalid-email") {
          yield RegisterErrorInvalidEmail();
        } else if (e.code == "operation-not-allowed") {
          yield RegisterErrorOperationNotAllowed();
        } else {
          yield RegisterError(error: e.toString());
        }
      } catch (e) {
        if (e is PseudoAlredyUsedException) {
          yield RegisterErrorPseudoAlreadyUsed();
        } else {
          yield RegisterErrorFirestore(error: e.toString());
        }
      }
    }

    if (event is LoginEvent) {
      try {
        User? user = await _provider.login(email: event.email.toLowerCase(), password: event.password);
        user!;
        Player? player = await _provider.getPlayer(uid: user.uid);
        player!;
        await doLogin(
            email: event.email,
            pseudo: player.pseudo,
            password: event.password,
            //token: token,
            userId: user.uid);

        yield AuthenticationSuccess();
      } catch (e) {
        yield AuthenticationError(error: 'Login failed');
      }
    }
    if (event is LogoutEvent) {
      try {
        await _provider.logout();
        doLogout();
        yield LoggedOut();
      } catch (e) {}
    }
    if (event is DeleteUserEvent) {
      yield AuthenticationProcessing();
      User? fireUser = _provider.dbAuth.currentUser;
      if (fireUser == null) {
        throw FireUserNotLogged();
      }
      try {
        await _provider.deletePlayer(uid: fireUser.uid);
        await fireUser.delete();
        await _provider.logout();
        doLogout();
        yield LoggedOut();
      } catch (e) {
        print("Error in DeleteUserEvent AuthBloc : " + e.toString());
      }
    }
  }
}
