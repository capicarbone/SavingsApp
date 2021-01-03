

import 'package:savings_app/models/account.dart';
import 'package:savings_app/models/category.dart';
import 'package:savings_app/models/fund.dart';
import 'package:savings_app/models/transaction.dart';

class FundTransactionsState {}

class FundTransactionsInitialState extends FundTransactionsState {}

class FundTransactionsLoadingState extends FundTransactionsState {}

class FundTransactionsUpdatedState extends FundTransactionsState {
  List<Transaction> transactions;
  Map<String, Fund> fundsMap;
  Map<String, Account> accountsMap;
  Map<String, Category> categoriesMap;

  FundTransactionsUpdatedState({this.transactions,
    this.accountsMap,
    this.fundsMap,
    this.categoriesMap
  });
}

class FundTransactionsLoadingFailed extends FundTransactionsState {
  String message;
}