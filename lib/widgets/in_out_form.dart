import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:savings_app/blocs/in_out_form/in_out_form_bloc.dart';
import 'package:savings_app/blocs/in_out_form/in_out_form_events.dart';
import 'package:savings_app/blocs/in_out_form/in_out_form_states.dart';
import 'package:savings_app/blocs/settings_syncer/settings_syncer_bloc.dart';
import 'package:savings_app/blocs/settings_syncer/settings_syncer_events.dart';
import 'package:savings_app/blocs/settings_syncer/settings_syncer_states.dart';

import 'package:savings_app/models/account.dart';
import 'package:savings_app/models/category.dart';
import 'package:savings_app/models/fund.dart';

import 'package:dropdown_search/dropdown_search.dart';

import '../blocs/in_out_form/in_out_form_states.dart';

class InOutForm extends StatefulWidget {
  final bool expenseMode;

  const InOutForm({this.expenseMode: false});

  @override
  _InOutFormState createState() => _InOutFormState();
}

class _InOutFormState extends State<InOutForm> {
  final _formKey = GlobalKey<FormState>();
  InOutFormBloc _bloc;
  FocusNode _descriptionNode;
  FocusNode _amountNode;

  final amountController = TextEditingController();
  final descriptionController = TextEditingController();

  Category _selectedCategory = null;
  String _selectedAccount = null;
  DateTime _selectedDate = DateTime.now();

  void _cleanForm() {
    _descriptionNode.unfocus();
    _amountNode.unfocus();

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

    // TODO: Create respositories in the InOutFormBloc

    _descriptionNode = FocusNode();
    _amountNode = FocusNode();

    _bloc = InOutFormBloc(
      expenseMode: widget.expenseMode,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionNode.dispose();
    _amountNode.dispose();
    amountController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        return _bloc;
      },
      child: BlocConsumer<InOutFormBloc, InOutFormState>(
          listenWhen: (_, current) =>
              current is InOutFormSubmitFailedState ||
              current is InOutFormSubmittedState,
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

              var syncerBloc = BlocProvider.of<SettingsSyncerBloc>(context);
              syncerBloc.add(ReloadLocalData(accounts: true, funds: true));
            }
          },
          builder: (ctx, state) {
            return Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    focusNode: _amountNode,
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
                              _selectedDate =
                                  value != null ? value : _selectedDate;
                            });
                          });
                        },
                      ),
                    ],
                  ),
                  BlocBuilder<SettingsSyncerBloc, SettingsSyncState>(
                      buildWhen: (_, dataState) =>
                          dataState is DataContainerState,
                      builder: (context, dataState) {
                        var data = dataState as DataContainerState;
                        return DropdownButtonFormField(
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
                          decoration:
                              const InputDecoration(hintText: "Account"),
                          items: [
                            ...data.settings.accounts.map((e) => DropdownMenuItem(
                                  child: Text(e.name),
                                  value: e.id,
                                ))
                          ],
                        );
                      }),
                  SizedBox(height: 24),
                  BlocBuilder<SettingsSyncerBloc, SettingsSyncState>(
                      buildWhen: (_, dataState) =>
                          dataState is DataContainerState &&
                          dataState.settings.categories != null,
                      builder: (context, dataState) {
                        var data = dataState as DataContainerState;

                        var categoriesFiltered =
                            data.settings.categories.where((category) {
                          if (widget.expenseMode) {
                            return !category.isIncome;
                          }

                          return category.isIncome;
                        }).toList();

                        categoriesFiltered.sort((categoryA, categoryB) =>
                            categoryA.name.compareTo(categoryB.name));

                        return DropdownSearch<Category>(
                          label: "Category",
                          items: categoriesFiltered,
                          selectedItem: _selectedCategory,
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          validator: (Category c) =>
                              c == null ? "Required" : null,
                          showSearchBox: true,
                          popupItemBuilder: (BuildContext context,
                              Category item, bool isSelected) {
                            return _categoryItemBuilder(
                                context, item, data.settings.funds, isSelected);
                          },
                          onChanged: (category) {
                            _selectedCategory = category;
                          },
                        );
                      }),
                  TextFormField(
                    controller: descriptionController,
                    focusNode: _descriptionNode,
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

  Fund _getCategoryFund(Category category, List<Fund> funds) {
    return funds.firstWhere(
        (element) => element.categories.indexOf(category) != -1,
        orElse: () => null);
  }

  Widget _categoryItemBuilder(
      BuildContext context, Category item, List<Fund> funds, bool isSelected) {
    var categoryFund = _getCategoryFund(item, funds);
    var fundName = (categoryFund == null) ? "" : categoryFund.name;
    return Container(
      child: ListTile(
        title: Text(item.name),
        subtitle: Text(fundName),
      ),
    );
  }
}
