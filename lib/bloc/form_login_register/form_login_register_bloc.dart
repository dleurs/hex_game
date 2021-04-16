import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hex_game/core/authentication/authentication_api_manager.dart';

part 'form_login_register_event.dart';
part 'form_login_register_state.dart';

class FormLoginRegisterBloc
    extends Bloc<FormLoginRegisterEvent, FormLoginRegisterState> {
  final AuthenticationApiProvider _provider;
  FormLoginRegisterBloc(this._provider) : super(FormLoginRegisterInitial());

  @override
  Stream<FormLoginRegisterState> mapEventToState(
    FormLoginRegisterEvent event,
  ) async* {
    if (event is CheckEmailEvent) {
      yield CheckEmailProcessing();
      try {
        bool isEmailExist =
            await _provider.isEmailAlreadyUsed(email: event.email);
        if (isEmailExist) {
          yield EmailAlreadyExist();
        } else {
          yield EmailDoesNotExist();
        }
      } catch (e) {
        yield CheckEmailError();
      }
    }
    if (event is CheckEmailReset) {
      yield FormLoginRegisterInitial();
    }
  }
}
