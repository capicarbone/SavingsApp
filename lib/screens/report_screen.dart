import 'package:flutter/material.dart';
import 'package:savings_app/models/period_statement.dart';
import 'package:savings_app/repositories/categories_repository.dart';
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
                text: "Accounts",
              ),
              Tab(
                text: "Funds",
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _CategoriesReport(
              categoriesChanges: statement.categories,
            ),
            _AccountsReports(),
            _FundsReports()
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
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Accounts"),
    );
  }
}

class _FundsReports extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Funds"),
    );
  }
}
