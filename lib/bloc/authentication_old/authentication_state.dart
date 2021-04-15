part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthenticationState {}

class AuthProcessing extends AuthenticationState {}

class AuthNo extends AuthenticationState {}

class AuthAnonymous extends AuthenticationState {
  final User firebaseUser;

  AuthAnonymous(this.firebaseUser);

  @override
  List<Object> get props => [firebaseUser];
}

class AuthEmail extends AuthenticationState {
  final User firebaseUser;
  final Player player;

  AuthEmail({required this.firebaseUser, required this.player});

  @override
  List<Object> get props => [firebaseUser, player];
}

class AuthError extends AuthenticationState {
  final String error;

  AuthError({required this.error});

  @override
  List<Object> get props => [error];
}
