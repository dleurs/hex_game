import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationState {}

class InitialAuthenticationState extends AuthenticationState {
  @override
  String toString() {
    return 'InitialAuthentication';
  }
}

class AuthenticationProcessing extends AuthenticationState {
  @override
  String toString() {
    return 'AuthenticationProcessing';
  }
}

class AuthenticationSuccess extends AuthenticationState {
  @override
  String toString() {
    return 'AuthenticationSuccess';
  }
}

class AuthenticationSuccessNoRedirect extends AuthenticationState {
  @override
  String toString() {
    return 'AuthenticationSuccessWithoutRedirect';
  }
}

class AuthenticationError extends AuthenticationState {
  final String? error;

  AuthenticationError({this.error});

  @override
  String toString() {
    return 'AuthenticationError';
  }
}

class LoggedOut extends AuthenticationState {
  @override
  String toString() {
    return 'LoggedOut';
  }
}

class RegisterErrorEmailAlreadyUsed extends AuthenticationState {
  @override
  String toString() {
    return 'RegisterErrorEmailAlreadyUsed';
  }
}

class RegisterErrorPseudoAlreadyUsed extends AuthenticationState {
  @override
  String toString() {
    return 'RegisterErrorPseudoAlreadyUsed';
  }
}

class RegisterErrorInvalidEmail extends AuthenticationState {
  @override
  String toString() {
    return 'RegisterErrorInvalidEmail';
  }
}

class RegisterErrorOperationNotAllowed extends AuthenticationState {
  @override
  String toString() {
    return 'RegisterErrorOperationNotAllowed';
  }
}

class RegisterErrorWeakPassword extends AuthenticationState {
  @override
  String toString() {
    return 'RegisterErrorWeakPassword';
  }
}

class RegisterError extends AuthenticationState {
  final String? error;

  RegisterError({this.error});

  @override
  String toString() {
    return 'RegisterError : ' + (error ?? "no string error");
  }
}

class RegisterErrorFirestore extends AuthenticationState {
  final String? error;

  RegisterErrorFirestore({this.error});

  @override
  String toString() {
    return 'RegisterErrorFirestore : ' + (error ?? "no string error");
  }
}

class LoggingErrorWrongPassword extends AuthenticationState {
  @override
  String toString() {
    return 'LoggingErrorWrongPassword';
  }
}
