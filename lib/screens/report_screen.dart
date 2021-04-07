import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

    var title = (statement.isYear) ? statement.year.toString() : DateFormat.MMMM().format(DateTime(1, statement.month));

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(112),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _StatementSummary(statement: statement,),
                SizedBox(height: 12,),
                TabBar(
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
              ],
            ),
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

class _StatementSummary extends StatelessWidget {

  PeriodStatement statement;

  _StatementSummary({this.statement});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Incomes", style: TextStyle(color: Colors.white),),
              CurrencyValue(statement.totalIncome, asChange: true,
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),)
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Expenses", style: TextStyle(color: Colors.white),),
              CurrencyValue(statement.totalExpense, asChange: true,
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),)
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Savings", style: TextStyle(color: Colors.white),),
              CurrencyValue(statement.totalIncome + statement.totalExpense, asChange: true,
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),)
            ],
          )
        ],
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
                  trailing: CurrencyValue(e.change, asChange: true),
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
                  trailing: CurrencyValue(e.change, asChange: true),
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
                  trailing: CurrencyValue(e.income + e.expense, asChange: true,),
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
                        CurrencyValue(e.income - e.expense, asChange: true),
                      ],
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }
}
