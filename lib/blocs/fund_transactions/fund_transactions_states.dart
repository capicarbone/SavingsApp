

import 'package:savings_app/models/transaction.dart';

class FundTransactionsState {}

class FundTransactionsInitialState extends FundTransactionsState {}

class FundTransactionsLoadingState extends FundTransactionsState {}

class FundTransactionsUpdatedState extends FundTransactionsState {
  List<Transaction> transactions;

  FundTransactionsUpdatedState({this.transactions});
}

class FundTransactionsLoadingFailed extends FundTransactionsState {
  String message;
}