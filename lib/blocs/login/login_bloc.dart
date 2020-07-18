

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/authentication/authentication_bloc.dart';
import 'package:savings_app/blocs/authentication/authentication_events.dart';
import 'package:savings_app/blocs/login/login_events.dart';
import 'package:savings_app/blocs/login/login_states.dart';
import 'package:savings_app/repositories/user_repository.dart';
import 'package:savings_app/validators.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {

  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    @required this.userRepository,
    @required this.authenticationBloc
}) : assert(userRepository != null), assert(authenticationBloc != null), super(LoginState.initial());
  
  @override
  Stream<Transition<LoginEvent, LoginState>> transformEvents(Stream<LoginEvent> events, transitionFn) {
    
    final nonDebounceStream = events.where((event) {
      return (event is! LoginEmailChanged && event is! LoginPasswordChanged);
    });

    final debounceStream = events.where((event) {
      return (event is LoginEmailChanged || event is LoginPasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));
    
    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), transitionFn);
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {

    if (event is LoginEmailChanged) {
      yield state.update(isEmailValid: Validators.isValidEmail(event.email));
    }

    if (event is LoginPasswordChanged) {
      yield state.update(isPasswordValid: Validators.isValidPassword(event.password));
    }

    if (event is LoginButtonPressed) {
      yield LoginState.loading();

      try {
        final token = await userRepository.getAuthToken(
            email: event.email,
            password: event.password
        );

        authenticationBloc.add(AuthenticationLoggedIn(token: token));
        yield LoginState.initial();
      } catch (error) {
        yield LoginState.failure(error.toString());
      }
    }
  }
}