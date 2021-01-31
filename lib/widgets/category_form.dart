
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/category_form/category_form_bloc.dart';
import 'package:savings_app/blocs/category_form/category_form_events.dart';
import 'package:savings_app/blocs/category_form/category_form_states.dart';
import 'package:savings_app/models/fund.dart';

class CategoryForm extends StatefulWidget {

  String authToken;
  List<Fund> funds;

  CategoryForm({this.authToken, this.funds});

  @override
  _CategoryFormState createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final nameController = TextEditingController();

  bool isIncome = false;
  String fundId = null;
  
  void _submitForm(context) {
    var bloc = BlocProvider.of<CategoryFormBloc>(context);
    
    var event = SubmitEvent(
      name: nameController.text,
      fundId: fundId,
      isIncome: isIncome
    );

    bloc.add(event);
  }

  @override
  Widget build(BuildContext _) {
    return BlocProvider(
      create: (_) {
        return CategoryFormBloc(authToken: widget.authToken);
      },
      child: BlocListener<CategoryFormBloc, CategoryFormState>(
        listener: (context, state) {
          if (state is SubmittedState) {
            Scaffold.of(context).showSnackBar(SnackBar(content: Text("Category added"),
            backgroundColor: Colors.green,));
          }
        },
        child: BlocBuilder<CategoryFormBloc,CategoryFormState>(
          builder: (ctx, state) => Form(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("New account".toUpperCase(),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor
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
                      Checkbox(value: isIncome, onChanged: (value) {
                        setState(() {
                          isIncome = value;
                        });
                      }),
                      Text("Is income category")
                    ],
                  ),
                  DropdownButtonFormField(
                    //value: categoryId,
                    decoration: const InputDecoration(hintText: "Fund"),
                      items: [
                    ...widget.funds.map((e) => DropdownMenuItem(child: Text(e.name), value: e.id,))
                  ]
                      , onChanged: (value) {
                      fundId = value;

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
