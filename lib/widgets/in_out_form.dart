import 'dart:ffi';

import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:savings_app/models/account.dart';
import 'package:savings_app/models/category.dart';
import 'package:savings_app/models/fund.dart';
import 'package:savings_app/repositories/transactions_repository.dart';

class InOutForm extends StatefulWidget {
  List<Fund> funds;
  List<Account> accounts;
  List<Category> categories;
  TransactionsRepository transactionsRepository;

  InOutForm({@required this.funds, @required this.accounts, this.transactionsRepository}) {
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

  void _submitForm() {
    if (_formKey.currentState.validate()) {
      widget.transactionsRepository.postTransaction( double.parse(amountController.text),
          _selectedAccount,
          _selectedCategory,
          DateTime.now(),
          descriptionController.text);
    }

  }

  String _validateAmount(String val) {
    try{
      var value = double.parse(val);

      if (value == 0) {
        return "Must be different than 0";
      }
    }
    catch (e) {
      return "Invalid value.";
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: amountController,
            keyboardType: TextInputType.number,
            validator: _validateAmount,
            decoration: const InputDecoration(
              hintText: "Amount",
            ),
          ),
          DropdownButtonFormField(
            onChanged: (accountId) {
              _selectedAccount = accountId;
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
              _selectedCategory =  categoryId;
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
            onPressed: () {
              _submitForm();
            },
          )
        ],
      ),
    );
  }
}
