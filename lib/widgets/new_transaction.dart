import 'package:flutter/material.dart';
import 'package:savings_app/models/account.dart';
import 'package:savings_app/models/category.dart';
import 'package:savings_app/models/fund.dart';
import 'package:savings_app/repositories/transactions_repository.dart';
import 'package:savings_app/widgets/account_transfer_form.dart';
import 'package:savings_app/widgets/in_out_form.dart';
import 'package:savings_app/widgets/nested_tabs/nested_tab_bar.dart';
import 'package:savings_app/widgets/nested_tabs/tab.dart';

class NewTransaction extends StatefulWidget {
  List<Fund> funds;
  List<Account> accounts;
  TransactionsRepository transactionsRepository;

  NewTransaction(
      {@required this.funds,
      @required this.accounts,
      @required this.transactionsRepository});

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {

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
                    text: "Income/Expense",
                  ),
                  NestedTab(text: "Account transfer"),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: IndexedStack(
                  index: _selectedTab,
                  children: [
                    InOutForm(
                      funds: widget.funds,
                      accounts: widget.accounts,
                      transactionsRepository: widget.transactionsRepository,
                    ),
                    AccountTransferForm(
                        accounts: widget.accounts,
                      transactionsRepository: widget.transactionsRepository,
                    ),
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
