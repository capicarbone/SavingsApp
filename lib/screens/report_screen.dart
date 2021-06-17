import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:savings_app/models/category.dart';
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

    var screen_title = "";

    switch (statement.level) {
      case 1: screen_title = "General"; break;
      case 2: screen_title = statement.year.toString(); break;
      case 3: screen_title = DateFormat.MMMM().format(DateTime(1, statement.month)); break;
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(screen_title),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(112),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _StatementSummary(
                  statement: statement,
                ),
                SizedBox(
                  height: 12,
                ),
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
              Text(
                "Incomes",
                style: TextStyle(color: Colors.white),
              ),
              CurrencyValue(
                statement.totalIncome,
                asChange: true,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Expenses",
                style: TextStyle(color: Colors.white),
              ),
              CurrencyValue(
                statement.totalExpense,
                asChange: true,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Savings",
                style: TextStyle(color: Colors.white),
              ),
              CurrencyValue(
                statement.totalIncome + statement.totalExpense,
                asChange: true,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              )
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

  List<Widget> _categoriesTiles(List<Category> categories) {
    return categories.map((e) {
      var change = categoriesChanges.firstWhere(
          (element) => element.categoryId == e.id,
          orElse: () => CategoryChange(null, 0));
      return ListTile(
        title: Text(e.name),
        trailing: CurrencyValue(change.change, asChange: true),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {

    var incomeCategories = repository.restoreIncomes()..sort((a,b) => a.name.compareTo(b.name));
    var expenseCategories = repository.restoreExpenses()..sort((a,b) => a.name.compareTo(b.name));

    return ListView(
      children: [
        ListTile(
          title: Text(
            "Incomes",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
        ..._categoriesTiles(incomeCategories),
        ListTile(
          title: Text(
            "Expenses",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
        ..._categoriesTiles(expenseCategories),
      ],
    );
  }
}

class _AccountsReports extends StatelessWidget {
  List<AccountChange> accountsChanges;

  _AccountsReports({this.accountsChanges});

  @override
  Widget build(BuildContext context) {
    var accounts = AccountsRepository().sortedRestore();
    return ListView(
      children: [
        ...accounts.map((account) {
          var change = accountsChanges.firstWhere(
              (element) => element.accountId == account.id,
              orElse: () => AccountChange(null, 0, 0));
          return ListTile(
            title: Text(account.name),
            trailing: CurrencyValue(
              change.income + change.expense,
              asChange: true,
            ),
          );
        })
      ],
    );
  }
}

class _FundsReports extends StatelessWidget {
  List<FundChange> fundsChanges;

  _FundsReports({this.fundsChanges});

  @override
  Widget build(BuildContext context) {
    var funds = FundsRepository().restoreSorted();

    return Container(
      child: ListView(
        children: [
          SizedBox(
            height: 18,
          ),
          ...funds.map((fund) {
            var change = fundsChanges.firstWhere(
                (element) => element.fundId == fund.id,
                orElse: () => FundChange(null, 0, 0));
            return ListTile(
              title: Text(fund.name),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CurrencyValue(change.income + change.expense, asChange: true),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
