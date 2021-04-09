part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent {}

class AppStartEvent extends AuthenticationEvent {}

class LoginAnonymousEvent extends AuthenticationEvent {}

class ConvertAnonymousToEmailEvent extends AuthenticationEvent {}

class LoginEmailEvent extends AuthenticationEvent {}

class RegisterEmailEvent extends AuthenticationEvent {}

class LogoutEvent extends AuthenticationEvent {}
