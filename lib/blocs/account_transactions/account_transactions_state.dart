import 'package:meta/meta.dart';
import 'package:savings_app/models/transaction.dart';

class AccountTransactionsState {}

class AccountTransactionsInitial extends AccountTransactionsState {}

class AccountTransactionsLoading extends AccountTransactionsState {}

class AccountTransactionsUpdated extends AccountTransactionsState{
  List<Transaction> transactions;

  AccountTransactionsUpdated({this.transactions});
}

class AccountTransactionsLoadingFailed extends AccountTransactionsState {
  String message;
}