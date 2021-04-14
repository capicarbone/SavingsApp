import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/category_form/category_form_bloc.dart';
import 'package:savings_app/blocs/category_form/category_form_events.dart';
import 'package:savings_app/blocs/category_form/category_form_states.dart';
import 'package:savings_app/blocs/settings_syncer/settings_syncer_bloc.dart';
import 'package:savings_app/blocs/settings_syncer/settings_syncer_events.dart';
import 'package:savings_app/models/fund.dart';

class CategoryForm extends StatelessWidget {
  String authToken;
  List<Fund> funds;

  CategoryForm({@required this.authToken, @required this.funds});

  final nameController = TextEditingController();

  void _submitForm(context) {
    var bloc = BlocProvider.of<CategoryFormBloc>(context);

    var event = SubmitEvent(name: nameController.text);

    bloc.add(event);
  }

  void _changeMode(BuildContext context, bool incomeMode) {
    var bloc = BlocProvider.of<CategoryFormBloc>(context);

    var event = ChangeModeEvent(incomeMode: incomeMode);
    bloc.add(event);
  }

  void _changeFund(BuildContext context, String fundId) {
    // ignore: close_sinks
    var bloc = BlocProvider.of<CategoryFormBloc>(context);

    var event = ChangeFundEvent(fundId: fundId);
    bloc.add(event);
  }

  void _onFormSubmitted(context) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("Category added."),
      backgroundColor: Colors.green,
    ));

    var syncerBloc = BlocProvider.of<SettingsSyncerBloc>(context);
    syncerBloc.add(ReloadLocalData(categories: true));

    _clear();
  }

  void _clear() {
    nameController.text = "";
  }

  String _getErrorMessage(CategoryFormError error) {
    switch (error) {
      case CategoryFormError.missingFund:
        return "Fund is required for expense categories";
      case CategoryFormError.missingName:
        return "Name is required";
      default:
        return "Form submit failed";
    }
  }

  Widget _react({Function builder}) {
    return BlocBuilder<CategoryFormBloc, CategoryFormState>(builder: builder);
  }

  void _listenState(context, state) {
    if (state is SubmittedState) {
      _onFormSubmitted(context);
    }

    if (state is SubmitFailedState) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(_getErrorMessage(state.error)),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CategoryFormBloc>(
      create: (_) {
        return CategoryFormBloc(authToken: authToken);
      },
      child: BlocListener<CategoryFormBloc, CategoryFormState>(
        listener: _listenState,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "New category".toUpperCase(),
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(hintText: "Name"),
              ),
              Row(
                children: [
                  _react(
                      builder: (ctx, state) => Checkbox(
                          value: state.incomeMode,
                          onChanged: (value) {
                            _changeMode(ctx, value);
                          })),
                  Text("Is income")
                ],
              ),
              _react(builder: (ctx, state) {
                if (!state.incomeMode)
                  return DropdownButtonFormField(
                      value: state.fundId,
                      decoration: const InputDecoration(hintText: "Fund"),
                      items: [
                        ...funds.map((e) => DropdownMenuItem(
                              child: Text(e.name),
                              value: e.id,
                            ))
                      ],
                      onChanged: (value) {
                        _changeFund(ctx, value);
                      });

                return Container();
              }),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _react(
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
        ),
      ),
    );
  }
}
