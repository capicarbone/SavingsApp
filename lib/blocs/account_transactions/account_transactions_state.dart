import 'package:meta/meta.dart';
import 'package:savings_app/models/account.dart';
import 'package:savings_app/models/category.dart';
import 'package:savings_app/models/fund.dart';
import 'package:savings_app/models/transaction.dart';

class AccountTransactionsState {}

class AccountTransactionsInitial extends AccountTransactionsState {}

class AccountTransactionsLoading extends AccountTransactionsState {}

class AccountTransactionsUpdated extends AccountTransactionsState{
  List<Transaction> transactions;
  Map<String, Account> accountsMap;
  Map<String, Category> categoriesMap;
  bool transactionDeleted;

  AccountTransactionsUpdated({this.transactions,
    this.accountsMap,
    this.categoriesMap,
    this.transactionDeleted});
}

class AccountTransactionsLoadingFailed extends AccountTransactionsState {
  String message;
}