import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/account_form/account_form_bloc.dart';
import 'package:savings_app/blocs/account_form/account_form_events.dart';
import 'package:savings_app/blocs/account_form/account_form_states.dart';
import 'package:savings_app/blocs/settings_syncer/settings_syncer_bloc.dart';
import 'package:savings_app/blocs/settings_syncer/settings_syncer_events.dart';

class AccountForm extends StatelessWidget {
  String authToken;
  var nameController = TextEditingController();

  AccountForm({this.authToken});

  void _submitForm(BuildContext ctx) {
    var event = SubmitEvent(name: nameController.text);

    BlocProvider.of<AccountFormBloc>(ctx).add(event);
  }

  Widget _buildForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "New account".toUpperCase(),
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          TextFormField(
            decoration: const InputDecoration(hintText: "Name"),
            controller: nameController,
          ),
          BlocBuilder<AccountFormBloc, AccountFormState>(
              builder: (ctx, state) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RaisedButton(
                          child: Text("Save"),
                          onPressed: (state is FormSubmittingState)
                              ? null
                              : () {
                                  _submitForm(ctx);
                                })
                    ],
                  )),
        ],
      ),
    );
  }

  void _listenState(BuildContext context, AccountFormState state) {
    if (state is FormSubmittedState) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Account added."),
        backgroundColor: Colors.green,
      ));

      BlocProvider.of<SettingsSyncerBloc>(context)
          .add(ReloadLocalData(accounts: true));
    }

    if (state is FormSubmitFailedState) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Submit failed."),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AccountFormBloc>(
      create: (_) => AccountFormBloc(authToken),
      child: BlocListener<AccountFormBloc, AccountFormState>(
          listener: _listenState, child: _buildForm(context)),
    );
  }
}
