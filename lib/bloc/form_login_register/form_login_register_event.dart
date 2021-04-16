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

class CheckEmailReset extends FormLoginRegisterEvent {
  @override
  List<Object> get props => [];
}
