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

  FundTransaction({@required this.fundId, @required this.change, this.fund});

  factory FundTransaction.fromMap(Map<String, dynamic> map, [Fund fund]) {
    return FundTransaction(
        fundId: map['fund'], change: map['change'], fund: fund);
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

  get isFundTransfer => fundTransactions.length == 2;

  get isIncome =>
      accountTransactions.length == 1 && accountTransactions[0].change > 0;

  get isExpense =>
      accountTransactions.length == 1 && accountTransactions[0].change < 0;

  factory Transaction.fromMap(Map<String, dynamic> map,
      [List<Category> categories, List<Account> accounts, List<Fund> funds]) {
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
      transaction.fundTransactions.addAll(fund_trasactions.map((e) {
        Fund fund = funds != null
            ? funds.firstWhere((element) => element.id == e['fund'],
                orElse: () => null)
            : null;
        return FundTransaction.fromMap(e, fund);
      }));
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

  FundTransaction transactionForFund(String fundId) {
    return fundTransactions.firstWhere((element) => element.fundId == fundId,
        orElse: () => null);
  }

  AccountTransaction transactionForAccount(String accountId) {
    // TODO: Return null if not found
    return accountTransactions.firstWhere(
        (element) => element.accountId == accountId,
        orElse: () => null);
  }

  FundTransaction getFundReceiver() {
    if (isFundTransfer){
      return fundTransactions.firstWhere((element) => element.change > 0);
    }
    return null;
  }

  FundTransaction getFundSource() {
    if (isFundTransfer){
      return fundTransactions.firstWhere((element) => element.change < 0);
    }
    return null;
  }

  AccountTransaction getAccountReceiver() {

    return accountTransactions.firstWhere((element) => element.change > 0);

  }

  AccountTransaction getAccountSource() {
    if (isAccountTransfer) {
      return accountTransactions.firstWhere((element) => element.change < 0);
    }

    return null;
  }
}
