import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hex_game/models/player.dart';
import 'package:meta/meta.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final FirebaseFirestore dbStore;
  final FirebaseAuth dbAuth;

  AuthenticationBloc({required this.dbStore, required this.dbAuth})
      : super(AuthInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is LoginEmailEvent) {
      yield* _mapAuthLoginEmailToState();
    }
  }

  Stream<AuthenticationState> _mapAuthLoginEmailToState() async* {
    yield AuthProcessing();
  }
}
