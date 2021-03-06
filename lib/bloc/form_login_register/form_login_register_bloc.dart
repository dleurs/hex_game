import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hex_game/core/authentication/authentication_api_manager.dart';

part 'form_login_register_event.dart';
part 'form_login_register_state.dart';

class FormLoginRegisterBloc extends Bloc<FormLoginRegisterEvent, FormLoginRegisterState> {
  final AuthenticationApiProvider _provider;
  String email;
  FormLoginRegisterBloc(this._provider, {this.email = ""}) : super(FormLoginRegisterInitial());

  @override
  Stream<FormLoginRegisterState> mapEventToState(
    FormLoginRegisterEvent event,
  ) async* {
    if (event is CheckEmailEvent) {
      yield EmailCheckProcessing();
      try {
        FirebaseAuthException isEmailExist = await _provider.isEmailAlreadyUsed(email: event.email);
        if (isEmailExist.code == "wrong-password") {
          yield EmailAlreadyExist();
        } else if (isEmailExist.code == "user-not-found") {
          yield EmailDoesNotExist();
        } else if (isEmailExist.code == "user-disabled") {
          yield EmailUserDisabled();
        } else if (isEmailExist.code == "too-many-requests") {
          yield EmailTooManyRequest();
        } else {
          // isEmailExist.code == "invalid-email" or users used the password in the code
          yield EmailInvalid();
        }
      } catch (e) {
        yield CheckEmailError();
      }
    }
    if (event is CheckEmailResetEvent) {
      yield FormLoginRegisterInitial();
    }
    if (event is WritingEmailEvent) {
      email = event.email;
    }
  }
}
