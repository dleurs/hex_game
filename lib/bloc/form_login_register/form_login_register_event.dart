part of 'form_login_register_bloc.dart';

abstract class FormLoginRegisterEvent extends Equatable {
  const FormLoginRegisterEvent();

  @override
  List<Object> get props => [];
}

class CheckEmailEvent extends FormLoginRegisterEvent {
  final String email;

  CheckEmailEvent({required this.email});

  @override
  List<Object> get props => [email];
}

class CheckEmailResetEvent extends FormLoginRegisterEvent {
  @override
  List<Object> get props => [];
}

class WritingEmailEvent extends FormLoginRegisterEvent {
  final String email;

  WritingEmailEvent({required this.email});

  @override
  List<Object> get props => [email];
}
