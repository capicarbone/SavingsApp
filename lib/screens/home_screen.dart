
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/authentication/authentication_bloc.dart';
import 'package:savings_app/blocs/authentication/authentication_events.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Container(
        child: Center(
          child: RaisedButton(
            child: Text("Logout"),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationLoggedOut());
            },
          ),
        ),
      ),
    );
  }
}
