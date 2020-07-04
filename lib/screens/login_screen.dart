import 'package:flutter/material.dart';
import 'dart:developer' as dev;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  var _formData = {
    'email': '',
    'password': ''
  };

  void _submit() {
    if (_formKey.currentState.validate()) {
      dev.log("Valid Form");
      _formKey.currentState.save();
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail ,
                  onSaved: (value) {
                    _formData['email'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: _validatePassword,
                  onSaved: (value) {
                    _formData['password'] = value;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  child: Text("Sign in"),
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).primaryTextTheme.button.color,
                  onPressed: _submit,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
