part of 'form_login_register_bloc.dart';

abstract class FormLoginRegisterState extends Equatable {
  const FormLoginRegisterState();

  @override
  List<Object> get props => [];
}

class FormLoginRegisterInitial extends FormLoginRegisterState {
  @override
  String toString() {
    return 'FormLoginRegisterInitial';
  }
}

class CheckEmailProcessing extends FormLoginRegisterState {
  @override
  String toString() {
    return 'CheckEmailProcessing';
  }
}

class EmailAlreadyExist extends FormLoginRegisterState {
  @override
  String toString() {
    return 'CheckEmailAlreadyExist';
  }
}

class EmailDoesNotExist extends FormLoginRegisterState {
  @override
  String toString() {
    return 'CheckEmailDoesNotExist';
  }
}

class CheckEmailError extends FormLoginRegisterState {
  final String? error;

  CheckEmailError({this.error});

  @override
  String toString() {
    return 'CheckEmailError{error: $error}';
  }
}
