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
import 'package:savings_app/repositories/accounts_repository.dart';
import 'package:savings_app/repositories/funds_repository.dart';
import 'package:savings_app/repositories/transactions_repository.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../blocs/in_out_form/in_out_form_states.dart';
import '../blocs/in_out_form/in_out_form_states.dart';

class InOutForm extends StatefulWidget {
  bool expenseMode = false;
  List<Fund> funds;
  List<Account> accounts;
  List<Category> categoriesFiltered;
  String authToken;

  InOutForm(
      {@required List<Category> categories,
        @required this.funds,
        @required this.accounts,
        @required this.authToken,
      this.expenseMode: false}) {
    categoriesFiltered = categories.where((category) {
      if (expenseMode){
        return !category.isIncome;
      }

      return category.isIncome;
    }).toList();

    categoriesFiltered.sort((categoryA, categoryB) =>
        categoryA.name.compareTo(categoryB.name) );

  }

  @override
  _InOutFormState createState() => _InOutFormState();
}

class _InOutFormState extends State<InOutForm> {
  final _formKey = GlobalKey<FormState>();
  InOutFormBloc _bloc;

  final amountController = TextEditingController();
  final descriptionController = TextEditingController();

  Category _selectedCategory = null;
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
        categoryId: _selectedCategory.id,
        description: descriptionController.text);

    bloc.add(event);
  }

  @override
  void initState() {
    super.initState();
    _bloc = InOutFormBloc(
      expenseMode: widget.expenseMode,
        transactionsRepository: TransactionsRepository(authToken: widget.authToken),
        accountsRepository: AccountsRepository(authToken: widget.authToken),
        fundsRepository: FundsRepository(authToken: widget.authToken));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        return _bloc;
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
                SizedBox(height: 24),
                DropdownSearch<Category>(
                  label: "Category",
                  items: widget.categoriesFiltered,
                  selectedItem: _selectedCategory,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  validator: (Category c) => c == null ? "Required" : null,
                  showSearchBox: true,
                  popupItemBuilder: _categoryItemBuilder,
                  onChanged: (category) {
                    _selectedCategory = category;
                  },
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

  Fund _getCategoryFund(Category category) {
    return widget.funds.firstWhere((element) => element.categories.indexOf(category) != -1, orElse: () => null);
  }

  Widget _categoryItemBuilder(BuildContext context, Category item, bool isSelected){
    var categoryFund = _getCategoryFund(item);
    var fundName = (categoryFund == null) ? "" : categoryFund.name;
    return Container(
      child: ListTile(
        title: Text(item.name),
        subtitle: Text(fundName),
      ),
    );
  }

  /*
  Widget _categoryDropdownBuilder(BuildContext context, Category item, String itemDesignation) {
    var categoryFund = _getCategoryFund(item);
    var fundName = (categoryFund == null) ? "" : categoryFund.name;
    return Container(
      child: ListTile(
        title: Text(item.name),
        subtitle: Text(fundName),
      ),
    );
  }
  */
}
