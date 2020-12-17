
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/authentication/authentication_events.dart';
import 'package:savings_app/blocs/authentication/authentication_states.dart';
import 'package:savings_app/models/account.dart';
import 'package:savings_app/models/category.dart';
import 'package:savings_app/models/fund.dart';
import 'package:savings_app/repositories/user_repository.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;

  AuthenticationBloc({@required this.userRepository}): assert(userRepository != null), super(AuthenticationInitial());

  @override
  AuthenticationState get initialState => AuthenticationInitial();

  /**
   * TODO:
   * I should move this method to something more related to application
   * startup/bootstrap.
   */
  Future<void> _initializeApp() async {
    await Hive.initFlutter();
    await Hive.openBox('user');
  }

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if (event is AuthenticationStarted) {
      await _initializeApp();

      final bool hasToken = await userRepository.hasToken();

      if (hasToken){
        var token = userRepository.restoreToken();

        await Hive.openBox<Category>('categories');
        await Hive.openBox<Account>('accounts');
        await Hive.openBox<Fund>('funds');

        yield AuthenticationSuccess(token: token);
      }else {
        yield AuthenticationFailure();
      }
    }

    if (event is AuthenticationLoggedIn) {
      yield AuthenticationInProgress();
      await userRepository.persistToken(event.token);
      yield AuthenticationSuccess(token: event.token);
    }

    if (event is AuthenticationLoggedOut) {
      yield AuthenticationInProgress();
      Hive.box<Category>('categories').clear();
      Hive.box<Account>('accounts').clear();
      Hive.box<Fund>('funds').clear();
      Hive.box('user').clear();
      yield AuthenticationFailure();
    }
  }
}