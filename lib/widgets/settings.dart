
import 'package:flutter/material.dart';
import 'package:savings_app/models/fund.dart';
import 'package:savings_app/widgets/account_form.dart';
import 'package:savings_app/widgets/category_form.dart';
import 'package:savings_app/widgets/fund_form.dart';

class SettingsScreen extends StatelessWidget {

  const SettingsScreen();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children:[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: AccountForm(),
            ),
          ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: CategoryForm(),
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: FundForm(),
            ),
          ),
        ],
      ),
    );
  }
}

