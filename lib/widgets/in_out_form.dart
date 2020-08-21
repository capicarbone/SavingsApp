import 'dart:ffi';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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
  DateTime _selectedDate = DateTime.now();

  void _cleanForm() {
    setState(() {
      _selectedDate = DateTime.now();
      amountController.text = "";
      descriptionController.text = "";
      _selectedAccount = null;
      _selectedCategory = null;
    });
  }

  void _submitForm(ctx) {
    var bloc = BlocProvider.of<InOutFormBloc>(ctx);

    var event = InOutFormSubmitEvent(
        amount: amountController.text,
        accomplishedAt: _selectedDate,
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
      child: BlocListener<InOutFormBloc, InOutFormState>(
        listener: (context, state) {
          if (state is InOutFormSubmitFailedState) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('An error has ocurred.'),
              backgroundColor: Colors.red,
            ));
          }

          if (state is InOutFormSubmittedState) {
            _cleanForm();
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("Transaction Saved"),
              backgroundColor: Colors.green,
            ));
          }
        },
        child:
            BlocBuilder<InOutFormBloc, InOutFormState>(builder: (ctx, state) {
          return Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  autovalidate: true,
                  validator: (v) {
                    if (state is InOutFormInvalidState &&
                        state.hasAmountError) {
                      return state.amountErrorMessage;
                    }

                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Amount",
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text(
                        DateFormat.yMd().format(_selectedDate),
                      ),
                    ),
                    RaisedButton(
                      child: Text("Pick a date"),
                      onPressed: () {
                        var now = DateTime.now();
                        showDatePicker(
                                context: ctx,
                                firstDate: DateTime(now.year - 1, 1, 1),
                                initialDate: _selectedDate,
                                lastDate: DateTime(now.year + 1, 1, 1))
                            .then((value) {
                          setState(() {
                            _selectedDate = value != null ? value : _selectedDate;
                          });
                        });
                      },
                    ),
                  ],
                ),
                DropdownButtonFormField(
                  onChanged: (accountId) {
                    _selectedAccount = accountId;
                  },
                  value: _selectedAccount,
                  autovalidate: true,
                  validator: (value) {
                    if (state is InOutFormInvalidState &&
                        state.hasAccountError) {
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
                  value: _selectedCategory,
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
      ),
    );
  }
}
