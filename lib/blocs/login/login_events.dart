
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable{
  const LoginEvent();
}

class LoginButtonPressed extends LoginEvent {
  final String email;
  final String password;

  const LoginButtonPressed({
    @required this.email,
    @required this.password
  });

  @override
  List<Object> get props => [email, password];
  
}

class LoginEmailChanged extends LoginEvent {
  final String email;

  const LoginEmailChanged({@required this.email});

  List<Object> get props => [email];

  @override
  String toString() {
    return 'LoginEmailChanged: $email';
  }
}

class LoginPasswordChanged extends LoginEvent {
  final String password;

  const LoginPasswordChanged({@required this.password});

  @override
  // TODO: implement props
  List<Object> get props => [password];

  @override
  String toString() {
    return 'LoginPasswordChanged: $password';
  }
}