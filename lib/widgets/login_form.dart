import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/login/login_bloc.dart';
import 'package:savings_app/blocs/login/login_events.dart';
import 'package:savings_app/blocs/login/login_states.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginBloc _loginBloc;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onLoginEmailChanged);
    _passwordController.addListener(_onLoginPasswordChanged);
  }

  void _onLoginEmailChanged() {
    _loginBloc.add(LoginEmailChanged(email: _emailController.text));
  }

  void _onLoginPasswordChanged() {
    _loginBloc.add(LoginPasswordChanged(password: _passwordController.text));
  }

  Widget _buildForm(LoginState state){

    _onLoginButtonPressed() {
      BlocProvider.of<LoginBloc>(context).add(
        LoginButtonPressed(
            email: _emailController.text,
            password: _passwordController.text
        ),
      );
    }

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'E-mail'),
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            autovalidate: true,
            validator: (_) {
              return !state.isEmailValid ? 'Invalid Email': null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            controller: _passwordController,
            autovalidate: true,
            validator: (_) {
              return !state.isPasswordValid ? "Invalid password" : null;
            },
          ),
          SizedBox(
            height: 20,
          ),
          RaisedButton(
            child: Text("Sign in"),
            color: Theme
                .of(context)
                .primaryColor,
            textColor: Theme
                .of(context)
                .primaryTextTheme
                .button
                .color,
            onPressed: state.isFormValid ? _onLoginButtonPressed : null,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {


    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isFailure) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.errorMessage}'),
              backgroundColor: Colors.red,
            )
          );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state.isSubmitting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
            return _buildForm(state);

        },
      ),
    );
  }
}

