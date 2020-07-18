
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/authentication/authentication_bloc.dart';
import 'package:savings_app/blocs/login/login_bloc.dart';
import 'package:savings_app/widgets/login_form.dart';
import 'dart:developer' as dev;
import '../repositories/user_repository.dart';

class LoginScreen extends StatelessWidget {

  final UserRepository userRepository;

  LoginScreen({Key key, @required this.userRepository})  : assert(userRepository != null), super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: BlocProvider(
            child: LoginForm(),
            create: (context) {
              return LoginBloc(
                authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
                userRepository: userRepository
              );
            },
          ),
        ),
      ),
    );
  }
}
