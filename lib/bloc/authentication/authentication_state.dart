import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationState {}

class InitialAuthenticationState extends AuthenticationState {
  @override
  String toString() {
    return 'InitialAuthenticationState';
  }
}

class AuthenticationProcessing extends AuthenticationState {
  @override
  String toString() {
    return 'AuthenticationProcessingState';
  }
}

class AuthenticationSuccess extends AuthenticationState {
  @override
  String toString() {
    return 'AuthenticationSuccessState';
  }
}

class SyncSuccessRefresh extends AuthenticationState {
  @override
  String toString() {
    return 'SyncSuccessState';
  }
}

class RefreshScreen extends AuthenticationState {
  @override
  String toString() {
    return 'SyncSuccessState';
  }
}

class AuthenticationError extends AuthenticationState {
  final String? error;

  AuthenticationError({this.error});

  @override
  String toString() {
    return 'AuthenticationErrorState';
  }
}

class LoggedOut extends AuthenticationState {
  @override
  String toString() {
    return 'LoggedOutState';
  }
}

class RegisterErrorEmailAlreadyUsed extends AuthenticationState {
  @override
  String toString() {
    return 'RegisterErrorEmailAlreadyUsed ';
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

/*           yield EmailAlreadyExist();
        } else if (e.code == "user-not-found") {
          yield EmailDoesNotExist();
        } else if (e.code == "user-disabled") {
          yield EmailUserDisabled();
        } else if (e.code == "too-many-requests") {
          yield EmailTooManyRequest(); */

class LoggingErrorWrongPassword extends AuthenticationState {
  @override
  String toString() {
    return 'LoggingErrorWrongPassword';
  }
}
