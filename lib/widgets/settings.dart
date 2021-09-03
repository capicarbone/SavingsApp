
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/authentication/authentication_bloc.dart';
import 'package:savings_app/blocs/authentication/authentication_events.dart';
import 'package:savings_app/widgets/account_form.dart';
import 'package:savings_app/widgets/category_form.dart';
import 'package:savings_app/widgets/fund_form.dart';
import 'package:savings_app/widgets/section_title.dart';

import 'content_surface.dart';

class SettingsScreen extends StatelessWidget {

  const SettingsScreen();

  @override
  Widget build(BuildContext context) {
    return ContentSurface(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:[
              SectionTitle(title: "Settings"),
              Card(
                child: AccountForm(),
              ),
                Card(
                  child: CategoryForm(),
                ),

              Card(
                child: FundForm(),
              ),
              OutlinedButton(onPressed: (){
                BlocProvider.of<AuthenticationBloc>(context)
                    .add(AuthenticationLoggedOut());
              }, child: Text("Logout"))
            ],
          ),
        ),
      ),
    );
  }
}

