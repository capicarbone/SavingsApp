class AccountMonthStatement {
  final String accountId;
  double income;
  double expense;

  AccountMonthStatement(this.accountId, this.income, this.expense);
}

class CategoryMonthStatement {
  final String categoryId;
  double change;

  CategoryMonthStatement(this.categoryId, this.change);
}

class FundMonthStatement {
  final String fundId;
  double income;
  double expense;

  FundMonthStatement(this.fundId, this.income, this.expense);
}

class MonthStatement {
  final int year;
  final int month;
  final List<AccountMonthStatement> accounts;
  final List<FundMonthStatement> funds;
  final List<CategoryMonthStatement> categories;

  MonthStatement(
      this.year, this.month, this.accounts, this.funds, this.categories);

  factory MonthStatement.fromMap(Map<String, dynamic> map) {
    var accountsChanges = (map['accounts'] as List)
        .map((e) =>
            AccountMonthStatement(e['account_id'], e['income'], e['expense']))
        .toList();

    var fundChanges = (map['funds'] as List)
        .map((e) =>
            FundMonthStatement(e['fund_id'], e['income'], e['expense']))
        .toList();

    var categorychanges = (map['categories'] as List)
        .map((e) => CategoryMonthStatement(e['category_id'], e['change']))
        .toList();

    return MonthStatement(map['year'], map['month'], accountsChanges,
        fundChanges, categorychanges);
  }
}
