import 'dart:ffi';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:savings_app/blocs/in_out_form/in_out_form_bloc.dart';
import 'package:savings_app/blocs/in_out_form/in_out_form_events.dart';
import 'package:savings_app/blocs/in_out_form/in_out_form_states.dart';
import 'package:savings_app/blocs/summary/summary_states.dart';
import 'package:savings_app/models/account.dart';
import 'package:savings_app/models/category.dart';
import 'package:savings_app/models/fund.dart';
import 'package:savings_app/repositories/transactions_repository.dart';

import '../blocs/in_out_form/in_out_form_states.dart';
import '../blocs/in_out_form/in_out_form_states.dart';

class InOutForm extends StatefulWidget {
  List<Fund> funds;
  List<Account> accounts;
  List<Category> categories;
  TransactionsRepository transactionsRepository;

  InOutForm(
      {@required this.funds,
      @required this.accounts,
      this.transactionsRepository}) {
    categories = [];

    funds.forEach((element) {
      categories.addAll(element.categories);
    });
  }

  @override
  _InOutFormState createState() => _InOutFormState();
}

class _InOutFormState extends State<InOutForm> {
  final _formKey = GlobalKey<FormState>();

  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
  String _selectedCategory = null;
  String _selectedAccount = null;

  void _submitForm(ctx) {
    var bloc = BlocProvider.of<InOutFormBloc>(ctx);

    var event = InOutFormSubmitEvent(
        amount: amountController.text,
        accountId: _selectedAccount,
        categoryId: _selectedCategory,
        description: descriptionController.text);

    bloc.add(event);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        return InOutFormBloc(
            transactionsRepository: widget.transactionsRepository);
      },
      child: BlocBuilder<InOutFormBloc, InOutFormState>(builder: (ctx, state) {
        return Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                autovalidate: true,
                validator: (v) {
                  if (state is InOutFormInvalidState && state.hasAmountError) {
                    return state.amountErrorMessage;
                  }

                  return null;
                },
                decoration: const InputDecoration(
                  hintText: "Amount",
                ),
              ),
              DropdownButtonFormField(
                onChanged: (accountId) {
                  _selectedAccount = accountId;
                },
                autovalidate: true,
                validator: (value) {
                  if (state is InOutFormInvalidState && state.hasAccountError) {
                    return state.accountErrorMessage;
                  }

                  return null;
                },
                decoration: const InputDecoration(hintText: "Account"),
                items: [
                  ...widget.accounts.map((e) => DropdownMenuItem(
                        child: Text(e.name),
                        value: e.id,
                      ))
                ],
              ),
              DropdownButtonFormField(
                onChanged: (categoryId) {
                  _selectedCategory = categoryId;
                },
                validator: (value) {
                  if (value == null) {
                    return "Required";
                  }

                  return null;
                },
                decoration: const InputDecoration(hintText: "Category"),
                items: [
                  ...widget.categories.map((e) => DropdownMenuItem(
                        child: Text(e.name),
                        value: e.id,
                      ))
                ],
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(hintText: "Description"),
              ),
              RaisedButton(
                child: Text("Save"),
                onPressed: (state is InOutFormSubmittingState)
                    ? null
                    : () {
                        _submitForm(ctx);
                      },
              )
            ],
          ),
        );
      }),
    );
  }
}
