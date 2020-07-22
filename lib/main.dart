import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/authentication/authentication_bloc.dart';
import 'package:savings_app/blocs/authentication/authentication_events.dart';
import 'package:savings_app/blocs/authentication/authentication_states.dart';
import 'package:savings_app/repositories/user_repository.dart';
import 'package:savings_app/screens/home_screen.dart';
import 'package:savings_app/screens/splash_screen.dart';
import 'screens/login_screen.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    print(event);
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(transition);
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stackTrace) {
    print(error);
    super.onError(bloc, error, stackTrace);
  }
}

void main() {
  Bloc.observer = SimpleBlocObserver();
  final userRepository = UserRepository();

  runApp(
    BlocProvider<AuthenticationBloc>(
      create: (context) {
        return AuthenticationBloc(userRepository: userRepository)..add(AuthenticationStarted());
      },
      child: MyApp(userRepository: userRepository),
    )
  );
}

class MyApp extends StatelessWidget {
  final UserRepository userRepository;

  MyApp({Key key, @required this.userRepository}): super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Savings App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {

          if (state is AuthenticationSuccess) {
            return HomeScreen(authToken: state.token,);
          }

          if (state is AuthenticationFailure) {
            return LoginScreen(userRepository: userRepository);
          }

          if (state is AuthenticationInProgress) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          //if (state is AuthenticationInitial) {
            return SplashScreen();
          //}
        },
      )
    );
  }
}