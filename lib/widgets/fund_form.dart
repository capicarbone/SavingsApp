import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/fund_form/fund_form_bloc.dart';
import 'package:savings_app/blocs/fund_form/fund_form_states.dart';
import 'package:savings_app/blocs/fund_form/fund_form_events.dart';
import 'package:savings_app/blocs/settings_syncer/settings_syncer_bloc.dart';
import 'package:savings_app/blocs/settings_syncer/settings_syncer_events.dart';
import 'package:savings_app/repositories/funds_repository.dart';

class FundForm extends StatelessWidget {
  String authToken;

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final assignmentController = TextEditingController();
  final minimumController = TextEditingController();
  final maximumController = TextEditingController();

  FundForm({@required this.authToken});

  void _submitForm(BuildContext context) {
    var event = SubmitEvent(
        name: nameController.text,
        description: descriptionController.text,
        assignment: assignmentController.text,
        minimumLimit: minimumController.text,
        maximumLimit: maximumController.text);

    var bloc = BlocProvider.of<FundFormBloc>(context);
    bloc.add(event);
  }

  void _clear() {
    // The form is already cleaned on success submit.
  }

  void _onFormSubmitted(BuildContext context) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("Fund added."),
      backgroundColor: Colors.green,
    ));

    var syncerBloc = BlocProvider.of<SettingsSyncerBloc>(context);
    syncerBloc.add(ReloadLocalData(funds: true));

    _clear();
  }

  Widget _listeState(context, state) {
    if (state is SubmittedState) {
      _onFormSubmitted(context);
    }

    if (state is SubmitFailedState) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(_getMessageForError(state.error)),
        backgroundColor: Colors.red,
      ));
    }
  }

  String _getMessageForError(FundFormError error) {
    switch (error) {
      case FundFormError.missingName:
        return "Name is missing";
      case FundFormError.invalidMinimum:
        return "Invalid minimum value";
      case FundFormError.invalidLimit:
        return "Invalid limit value";
      case FundFormError.invalidAssignment:
        return "Invalid assignment value";
      case FundFormError.missingAssignment:
        return "Assignment is missing";
      case FundFormError.overassignment:
        return "Total assignment is greater than 100%";
      default:
        return "Error submitting form";
    }
  }

  Widget _buildForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "New Fund".toUpperCase(),
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          TextFormField(
            decoration: const InputDecoration(hintText: "Name"),
            controller: nameController,
          ),
          TextFormField(
            decoration: const InputDecoration(hintText: "Description"),
            controller: descriptionController,
          ),
          TextFormField(
            decoration: const InputDecoration(
                hintText: "Assignment", suffix: Text("%")),
            controller: assignmentController,
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BlocBuilder<FundFormBloc, FundFormState>(builder: (ctx, state) =>
                  Text(
                    "${(state.availableAssignment*100).round()}% Available for assignment",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.end,
                  )
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                      hintText: "Minimum", suffix: Text("\$")),
                  controller: minimumController,
                ),
              ),
              SizedBox(
                width: 30,
              ),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                      hintText: "Limit", suffix: Text("\$")),
                  controller: maximumController,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<FundFormBloc, FundFormState>(
                  builder: (ctx, state) => RaisedButton(
                      child: Text("Save"),
                      onPressed: (state is SubmittingState)
                          ? null
                          : () {
                              _submitForm(ctx);
                            }))
            ],
          )
        ],
      ),
    );
  }

  FundFormBloc _createBloc(_) => FundFormBloc(repository: FundsRepository(authToken: authToken));

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FundFormBloc>(
      create: _createBloc,
      child: BlocListener<FundFormBloc, FundFormState>(
        listener: _listeState,
        child: _buildForm(context),
      ),
    );
  }
}
