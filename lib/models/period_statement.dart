class AccountChange {
  final String accountId;
  double income;
  double expense;

  AccountChange(this.accountId, this.income, this.expense);
}

class CategoryChange {
  final String categoryId;
  double change;

  CategoryChange(this.categoryId, this.change);
}

class FundChange {
  final String fundId;
  double income;
  double expense;

  FundChange(this.fundId, this.income, this.expense);
}

class PeriodStatement {
  final int year;
  final int month;
  final List<AccountChange> accounts;
  final List<FundChange> funds;
  final List<CategoryChange> categories;

  PeriodStatement(
      this.year, this.month, this.accounts, this.funds, this.categories);

  bool get isYear => month == null;

  factory PeriodStatement.fromMap(Map<String, dynamic> map) {
    var accountsChanges = (map['accounts'] as List)
        .map((e) => AccountChange(e['account_id'], e['income'], e['expense']))
        .toList();

    var fundChanges = (map['funds'] as List)
        .map((e) => FundChange(e['fund_id'], e['income'], e['expense']))
        .toList();

    var categorychanges = (map['categories'] as List)
        .map((e) => CategoryChange(e['category_id'], e['change']))
        .toList();

    return PeriodStatement(map['year'], map['month'], accountsChanges,
        fundChanges, categorychanges);
  }


  factory PeriodStatement.computeYear(
      int year, List<PeriodStatement> statements) {
    final accountsChanges = <AccountChange>[];
    final fundsChanges = <FundChange>[];
    final categoriesChanges = <CategoryChange>[];

    var accounts = Set.from(statements
        .map((e) => e.accounts.map((e) => e.accountId).toList())
        .expand((element) => element));

    var funds = Set.from(statements
        .map((e) => e.funds.map((e) => e.fundId).toList())
        .expand((element) => element));

    var categories = Set.from(statements
        .map((e) => e.categories.map((e) => e.categoryId).toList())
        .expand((element) => element));

    accounts.forEach((accountId) {
      final accountChange = AccountChange(accountId, 0, 0);
      statements.forEach((statement) {
        var change = statement.getAccountChange(accountId);
        if (change != null) {
          accountChange.expense += change.expense;
          accountChange.income += change.income;
        }
      });

      accountsChanges.add(accountChange);
    });

    funds.forEach((fundId) {
      final fundChange = FundChange(fundId, 0, 0);
      statements.forEach((statement) {
        var change = statement.getFundChange(fundId);
        if (change != null) {
          fundChange.expense += change.expense;
          fundChange.income += change.income;
        }
      });

      fundsChanges.add(fundChange);
    });

    categories.forEach((categoryId) {
      final categoryChange = CategoryChange(categoryId, 0);
      statements.forEach((statement) {
        var change = statement.getCategoryChange(categoryId);
        if (change != null) {
          categoryChange.change += change.change;
        }
      });

      categoriesChanges.add(categoryChange);
    });

    return PeriodStatement(
        year, null, accountsChanges, fundsChanges, categoriesChanges);
  }

  AccountChange getAccountChange(String id) {
    return accounts.firstWhere((element) => element.accountId == id,
        orElse: () => null);
  }

  FundChange getFundChange(String id) {
    return funds.firstWhere((element) => element.fundId == id,
        orElse: () => null);
  }

  CategoryChange getCategoryChange(String id) {
    return categories.firstWhere((element) => element.categoryId == id,
        orElse: () => null);
  }

  double get totalIncome => accounts.fold(0, (value, element) => value + element.income);

  double get totalExpense => accounts.fold(0, (value, element) => value + element.expense);

  double get savingsRatio {
    var income = this.totalIncome;
    var expense = this.totalExpense;

    return ((income + expense) / income)*100;
  }
}
