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

class WrongPassword extends AuthenticationState {
  final String? error;

  WrongPassword({this.error});

  @override
  String toString() {
    return 'WrongPassword';
  }
}

class LoggedOut extends AuthenticationState {
  @override
  String toString() {
    return 'LoggedOutState';
  }
}
