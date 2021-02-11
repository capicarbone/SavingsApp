
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
    
    var event = SubmitEvent(
      name: nameController.text
    );

    bloc.add(event);
  }

  void _changeMode(BuildContext context, bool incomeMode) {
    var bloc = BlocProvider.of<CategoryFormBloc>(context);

    var event = ChangeModeEvent(incomeMode: incomeMode);
    bloc.add(event);

  }

  void _changeFund(BuildContext context, String fundId){
    var bloc = BlocProvider.of<CategoryFormBloc>(context);

    var event = ChangeFundEvent(fundId: fundId);
    bloc.add(event);
  }

  void _onFormSubmitted(context){
    Scaffold.of(context).showSnackBar(SnackBar(content: Text("Category added."),
      backgroundColor: Colors.green,));

    var syncerBloc = BlocProvider.of<SettingsSyncerBloc>(context);
    syncerBloc.add(SettingsSyncerDataUpdated());

    _clear();
  }

  void _clear(){
    nameController.text = "";
  }

  @override
  Widget build(BuildContext _) {
    return BlocProvider(
      create: (_) {
        return CategoryFormBloc(authToken: authToken);
      },
      child: BlocListener<CategoryFormBloc, CategoryFormState>(
        listener: (context, state) {
          if (state is SubmittedState) {
            _onFormSubmitted(context);
          }

          if (state is SubmitFailedState) {
            Scaffold.of(context).showSnackBar(SnackBar(content: Text("Form submit failed."),
              backgroundColor: Colors.red,));
          }
        },
        child: BlocBuilder<CategoryFormBloc,CategoryFormState>(
          builder: (ctx, state) => Form(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("New category".toUpperCase(),
                    style: TextStyle(
                      color: Theme.of(ctx).primaryColor
                   ),
                  ),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: "Name"
                    ),

                  ),
                  Row(
                    children: [
                      Checkbox(value: state.incomeMode, onChanged: (value) {
                        _changeMode(ctx, value);
                      }),
                      Text("Is income")
                    ],
                  ),
                  if (!state.incomeMode)
                  DropdownButtonFormField(
                    value: state.fundId,
                    decoration: const InputDecoration(hintText: "Fund"),
                      items: [
                    ...funds.map((e) => DropdownMenuItem(child: Text(e.name), value: e.id,))
                  ]
                      , onChanged:  (value) {
                      _changeFund(ctx, value);

                  }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    RaisedButton(
                        child: Text("Save"),
                        onPressed: () {
                          _submitForm(ctx);
                        })
                  ],)

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
