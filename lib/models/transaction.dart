import 'package:meta/meta.dart';
import 'package:savings_app/models/account.dart';
import 'package:savings_app/models/category.dart';
import 'package:savings_app/models/fund.dart';

class AccountTransaction {
  final String accountId;
  final Account account;
  final double change;

  AccountTransaction(
      {@required this.accountId, @required this.change, this.account});

  factory AccountTransaction.fromMap(Map<String, dynamic> map,
      [Account account]) {
    return AccountTransaction(
        accountId: map['account'], change: map['change'], account: account);
  }
}

class FundTransaction {
  final String fundId;
  final Fund fund;
  final double change;

  FundTransaction(
      {@required this.fundId, @required this.change, this.fund: null});

  factory FundTransaction.fromMap(Map<String, dynamic> map) {
    return FundTransaction(fundId: map['fund'], change: map['change']);
  }
}

class Transaction {
  final String id;
  final String description;
  final String categoryId;
  final Category category;
  final DateTime dateAccomplished;
  final List<AccountTransaction> accountTransactions = [];
  final List<FundTransaction> fundTransactions = [];

  Transaction(
      {this.id,
      this.description,
      this.categoryId,
      this.dateAccomplished,
      this.category: null});

  get isAccountTransfer => accountTransactions.length == 2;

  get isIncome =>
      accountTransactions.length == 1 && accountTransactions[0].change > 0;

  get isExpense =>
      accountTransactions.length == 1 && accountTransactions[0].change < 0;

  factory Transaction.fromMap(Map<String, dynamic> map,
      [List<Category> categories, List<Account> accounts]) {
    var category = null;

    if (categories != null && map['category'] != null) {
      category =
          categories.firstWhere((element) => element.id == map['category']);
    }

    if (accounts != null && map['account_transactions'] != null) {}

    var transaction = Transaction(
        id: map['id'],
        description: map['description'],
        dateAccomplished: DateTime.parse(map['date_accomplished']),
        categoryId: map['category'],
        category: category);

    List<dynamic> fund_trasactions = map['fund_transactions'];
    List<dynamic> account_transactions = map['account_transactions'];

    if (fund_trasactions != null) {
      transaction.fundTransactions
          .addAll(fund_trasactions.map((e) => FundTransaction.fromMap(e)));
    }

    if (account_transactions != null) {
      transaction.accountTransactions.addAll(account_transactions.map((e) {
        Account account = accounts != null
            ? accounts.firstWhere((element) => element.id == e['account'],
                orElse: () => null)
            : null;

        return AccountTransaction.fromMap(e, account);
      }));
    }

    return transaction;
  }

  AccountTransaction transactionForAccount(String accountId) {
    // TODO: Return null if not found
    return accountTransactions
        .firstWhere((element) => element.accountId == accountId);
  }

  AccountTransaction getAccountTransferReceiver() {
    if (isAccountTransfer) {
      return accountTransactions.firstWhere((element) => element.change > 0);
    }
    return null;
  }

  AccountTransaction getAccountTransferSource() {
    if (isAccountTransfer) {
      return accountTransactions.firstWhere((element) => element.change < 0);
    }

    return null;
  }
}
