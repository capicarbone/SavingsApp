import 'package:flutter/material.dart';
import 'package:savings_app/models/period_statement.dart';
import 'package:savings_app/repositories/accounts_repository.dart';
import 'package:savings_app/repositories/categories_repository.dart';
import 'package:savings_app/repositories/funds_repository.dart';
import 'package:savings_app/widgets/currency_value.dart';

class ReportScreen extends StatelessWidget {
  static const routeName = '/report';

  PeriodStatement statement;

  @override
  Widget build(BuildContext context) {
    var args =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    PeriodStatement statement = args['statement'];

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Report"),
          bottom: TabBar(
            tabs: [
              Tab(
                text: "Categories",
              ),
              Tab(
                text: "Funds",
              ),
              Tab(
                text: "Accounts",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _CategoriesReport(
              categoriesChanges: statement.categories,
            ),
            _FundsReports(
              fundsChanges: statement.funds,
            ),
            _AccountsReports(
              accountsChanges: statement.accounts,
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoriesReport extends StatelessWidget {
  List<CategoryChange> categoriesChanges;
  CategoriesRepository repository = CategoriesRepository();

  _CategoriesReport({this.categoriesChanges});

  @override
  Widget build(BuildContext context) {
    var categoriesNames = {
      for (var e in categoriesChanges)
        e.categoryId: repository.restoreById(e.categoryId).name
    };

    var compareChanges = (a, b) =>
        categoriesNames[a.categoryId].compareTo(categoriesNames[b.categoryId]);

    var incomeChanges = categoriesChanges
        .where((element) => repository.restoreById(element.categoryId).isIncome)
        .toList()
          ..sort(compareChanges);
    var expenseChanges = categoriesChanges
        .where(
            (element) => !repository.restoreById(element.categoryId).isIncome)
        .toList()
          ..sort(compareChanges);

    return ListView(
      children: [
        if (incomeChanges.length > 0)
          ListTile(
            title: Text(
              "Incomes",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
        ...incomeChanges
            .map((e) => ListTile(
                  title: Text(categoriesNames[e.categoryId]),
                  trailing: CurrencyValue(e.change, true),
                ))
            .toList(),
        if (expenseChanges.length > 0)
          ListTile(
            title: Text(
              "Expenses",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
        ...expenseChanges
            .map((e) => ListTile(
                  title: Text(categoriesNames[e.categoryId]),
                  trailing: CurrencyValue(e.change, true),
                ))
            .toList(),
      ],
    );
  }
}

class _AccountsReports extends StatelessWidget {
  List<AccountChange> accountsChanges;

  _AccountsReports({this.accountsChanges});

  @override
  Widget build(BuildContext context) {
    var repository = AccountsRepository();

    var accountsNames = {
      for (var e in accountsChanges)
        e.accountId: repository.restoreById(e.accountId).name
    };

    accountsChanges.sort((a, b) =>
        accountsNames[a.accountId].compareTo(accountsNames[b.accountId]));

    return ListView(
      children: [
        ...accountsChanges
            .map((e) => ListTile(
                  title: Text(accountsNames[e.accountId]),
                  trailing: CurrencyValue(e.income - e.expense),
                ))
            .toList()
      ],
    );
  }
}

class _FundsReports extends StatelessWidget {
  List<FundChange> fundsChanges;

  _FundsReports({this.fundsChanges});

  @override
  Widget build(BuildContext context) {
    var repository = FundsRepository();
    var fundsNames = {
      for (var e in fundsChanges)
        e.fundId: repository.restoreById(e.fundId).name
    };

    fundsChanges
        .sort((a, b) => fundsNames[a.fundId].compareTo(fundsNames[b.fundId]));

    return Container(
      child: ListView(
        children: [
          SizedBox(
            height: 18,
          ),
          ...fundsChanges
              .map((e) => ListTile(
                    title: Text(fundsNames[e.fundId]),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CurrencyValue(e.income - e.expense, true),
                      ],
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }
}
