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

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var _formData = {
    'email': '',
    'password': ''
  };

  void _submit() {
    if (_formKey.currentState.validate()) {
//      dev.log("Valid Form");
      _formKey.currentState.save();
   //   UserRepository().getAuthToken(email: _formData['email'], password: _formData['password']);
    }
  }

  /*
  String _validateEmail(String value){
    if (value.isEmpty){
      return "Email is empty";
    }

    if (!value.contains("@")  || !value.contains(".")){
      return "Not a valid email";
    }
  }

  String _validatePassword(String value){
    if (value.isEmpty || value.length < 5) {
      return 'Password is too short!';
    }
  }
*/

  @override
  Widget build(BuildContext context) {

    _onLoginButtonPressed() {
      BlocProvider.of<LoginBloc>(context).add(
        LoginButtonPressed(
          username: _usernameController.text,
          password: _passwordController.text
        ),
      );
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.error}'),
              backgroundColor: Colors.red,
            )
          );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
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
                  controller: _usernameController,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
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
                  onPressed: state is! LoginInProgress ? _onLoginButtonPressed : null,
                ),
                Container(
                  child: state is LoginInProgress ? CircularProgressIndicator() : null,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

