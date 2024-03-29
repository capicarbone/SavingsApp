import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:savings_app/blocs/authentication/authentication_bloc.dart';
import 'package:savings_app/blocs/authentication/authentication_events.dart';
import 'package:savings_app/blocs/authentication/authentication_states.dart';
import 'package:savings_app/models/account.dart';
import 'package:savings_app/models/category.dart';
import 'package:savings_app/models/fund.dart';
import 'package:savings_app/repositories/user_repository.dart';
import 'package:savings_app/screens/report_screen.dart';
import 'package:savings_app/screens/account_details_screen.dart';
import 'package:savings_app/screens/fund_details_screen.dart';
import 'package:savings_app/screens/home_screen.dart';
import 'package:savings_app/screens/splash_screen.dart';
import 'package:savings_app/widgets/new_transaction.dart';
import 'screens/login_screen.dart';
import 'package:hive/hive.dart';

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

void main() async {
  await dotenv.load();

  Bloc.observer = SimpleBlocObserver();
  final userRepository = UserRepository();

  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(AccountAdapter());
  Hive.registerAdapter(FundAdapter());

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
      ),
      routes: {
        AccountDetailsScreen.routeName: (context) => AccountDetailsScreen(),
        FundDetailsScreen.routeName: (context) => FundDetailsScreen(),
        ReportScreen.routeName: (context) => ReportScreen(),
        NewTransactionScreen.routeName: (_) => NewTransactionScreen()
      },
    );
  }
}