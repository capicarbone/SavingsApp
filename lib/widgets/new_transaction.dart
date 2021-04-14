import 'package:flutter/material.dart';
import 'package:savings_app/models/account.dart';
import 'package:savings_app/models/category.dart';
import 'package:savings_app/models/fund.dart';
import 'package:savings_app/repositories/transactions_repository.dart';
import 'package:savings_app/widgets/account_transfer_form.dart';
import 'package:savings_app/widgets/in_out_form.dart';
import 'package:savings_app/widgets/nested_tabs/nested_tab_bar.dart';
import 'package:savings_app/widgets/nested_tabs/tab.dart';

class NewTransactionScreen extends StatefulWidget {

  const NewTransactionScreen();

  @override
  _NewTransactionScreenState createState() => _NewTransactionScreenState();
}

class _NewTransactionScreenState extends State<NewTransactionScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              NestedTabBar(
                onTap: (position) {
                  setState(() {
                    _selectedTab = position;
                  });
                },
                tabs: [
                  NestedTab(
                    text: "Expense",
                  ),
                  NestedTab(
                    text: "Income",
                  ),
                  NestedTab(text: "Transfer"),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: IndexedStack(
                  index: _selectedTab,
                  children: [
                    const InOutForm(expenseMode: true,),
                    const InOutForm(),
                    const AccountTransferForm(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
