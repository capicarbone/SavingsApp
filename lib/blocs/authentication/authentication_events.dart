
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationStarted extends AuthenticationEvent {}

class AuthenticationLoggedIn extends AuthenticationEvent {
  final String token;

  const AuthenticationLoggedIn({@required this.token});

  List<Object> get props => [token];

  @override
  String toString() {
    return "AuthenticationLoggedIn { token: $token }";
  }
}

class AuthenticationLoggedOut extends AuthenticationEvent {}