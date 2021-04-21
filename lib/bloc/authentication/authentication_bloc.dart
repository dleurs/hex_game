import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hex_game/core/authentication/authentication_api_manager.dart';
import 'package:hex_game/core/authentication/authentication_manager.dart';
import 'package:hex_game/models/authentication/token.dart';
import 'package:tuple/tuple.dart';

import './bloc.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationApiProvider _provider;

  AuthenticationBloc(this._provider) : super(InitialAuthenticationState());

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    yield AuthenticationProcessing();

    if (event is LoadLocalAuthenticationManager) {
      if (AuthenticationManager.instance.isLoggedIn == null || AuthenticationManager.instance.isLoggedIn == false) {
        await AuthenticationManager.load();
      }
      yield AuthenticationSuccess();
    }

/*     if (event is RegisterEvent) {
      try {
        Tuple2<Token, String> tuble = await _provider.register(
            email: event.login.toLowerCase(), password: event.password);
        Token token = tuble.item1;
        String userId = tuble.item2;
        await AuthenticationManager.instance.doLogin(
            login: event.login,
            password: event.password,
            token: token,
            userId: userId);
        yield AuthenticationSuccess();
      } catch (e) {
        yield AuthenticationError(error: 'Login failed');
      }
    } */

    if (event is LoginEvent) {
      try {
        User? user = await _provider.login(email: event.login.toLowerCase(), password: event.password);
        await AuthenticationManager.instance.doLogin(
            login: event.login,
            password: event.password,
            //token: token,
            userId: user!.uid);
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
