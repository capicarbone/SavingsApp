
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';


abstract class AuthenticationState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {
  String token;

  AuthenticationSuccess({@required this.token});

  @override
  List<Object> get props => [token];
}

class AuthenticationFailure extends AuthenticationState {}

class AuthenticationInProgress extends AuthenticationState {}