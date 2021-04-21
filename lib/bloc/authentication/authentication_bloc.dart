import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hex_game/core/authentication/authentication_api_manager.dart';
import 'package:hex_game/core/authentication/authentication_manager.dart';
import 'package:hex_game/models/player.dart';

import './bloc.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationApiProvider _provider;

  AuthenticationBloc(this._provider) : super(InitialAuthenticationState());

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    yield AuthenticationProcessing();

    if (event is SynchroniseAuthenticationManager) {
      try {
        //await AuthenticationManager.load();
        User? user = _provider.dbAuth.currentUser;
        if (user == null || user.uid.isEmpty) {
          await AuthenticationManager.instance.doLogout();
        }
        if (AuthenticationManager.instance.uid == null && user != null && user.uid.isNotEmpty) {
          String? pseudo;
          if (user.email != null) {
            Player? player = await _provider.getPlayer(uid: user.uid);
            pseudo = player!.pseudo;
          }
          AuthenticationManager.instance.updateCredentials(email: user.email, pseudo: pseudo, uid: user.uid);
        }
      } catch (e) {}
      yield SyncSuccess();
    }
    if (event is RegisterEvent) {
      try {
        User? user = await _provider.register(email: event.email.toLowerCase(), password: event.password);
        user!;
        await AuthenticationManager.instance.doLogin(
            email: event.email,
            pseudo: event.pseudo,
            password: event.password,
            //token: token,
            userId: user.uid);
        Player player = Player(uid: user.uid, pseudo: event.pseudo);
        await _provider.updatePlayer(player: player, operation: SaveFirestoreOperation.emailRegister);
        yield AuthenticationSuccess();
      } catch (e) {
        yield AuthenticationError(error: 'Login failed');
      }
    }

    if (event is LoginEvent) {
      try {
        User? user = await _provider.login(email: event.email.toLowerCase(), password: event.password);
        user!;
        Player? player = await _provider.getPlayer(uid: user.uid);
        player!;
        await AuthenticationManager.instance.doLogin(
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
        AuthenticationManager.instance.doLogout();
        yield LoggedOut();
      } catch (e) {}
    }
    if (event is ResetEvent) {
      yield InitialAuthenticationState();
    }
  }
}
