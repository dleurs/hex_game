import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hex_game/core/authentication/authentication_api_manager.dart';
import 'package:hex_game/core/authentication/authentication_manager.dart';
import 'package:hex_game/models/player.dart';
import 'package:hex_game/utils/exceptions.dart';

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
        } else {
          AuthenticationManager.instance.updateCredentials(email: user.email, uid: user.uid);
        }
        if (AuthenticationManager.instance.pseudo == null && user != null && user.uid.isNotEmpty) {
          Player? player = await _provider.getPlayer(uid: user.uid);
          AuthenticationManager.instance.updateCredentials(pseudo: player!.pseudo);
        }
      } catch (e) {}
      yield SyncSuccessRefresh();
    }
    if (event is RefreshScreen) {
      yield SyncSuccessRefresh();
    }
    if (event is RegisterEvent) {
      try {
        bool pseudoAlreadyUsed = await _provider.isPseudoAlreadyUsed(pseudo: event.pseudo);
        if (pseudoAlreadyUsed) {
          throw PseudoAlredyUsedException();
        }
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
