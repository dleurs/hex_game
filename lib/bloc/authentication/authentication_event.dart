import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {}

class LoginEvent extends AuthenticationEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email];
}

class RegisterEvent extends AuthenticationEvent {
  final String email;
  final String pseudo;
  final String password;

  RegisterEvent({required this.email, required this.pseudo, required this.password});

  @override
  List<Object> get props => [email, pseudo];
}

class LogoutEvent extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}

class DeleteUserEvent extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}

class SynchroniseAuthentication extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}
