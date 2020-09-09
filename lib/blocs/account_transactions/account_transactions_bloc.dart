
import 'dart:developer';

import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/account_transactions/account_transactions_events.dart';
import 'package:savings_app/blocs/account_transactions/account_transactions_state.dart';
import 'package:savings_app/repositories/transactions_repository.dart';

class AccountTransactionsBloc extends Bloc<AccountTransactionsEvent, AccountTransactionsState>{

  String accountId;
  TransactionsRepository transactionsRepository;

  AccountTransactionsBloc({@required this.accountId,@required this.transactionsRepository}) : super(AccountTransactionsInitial());


  @override
  Stream<AccountTransactionsState> mapEventToState(AccountTransactionsEvent event) async* {

    var transactionDeleted = false;

    if (event is AccountTransactionsDeleteEvent) {
      try {
        transactionsRepository.deleteTransaction(accountId, event.transactionId);
        transactionDeleted = true;
      }catch(e, trace) {
        log(e.toString(), error: e, stackTrace: trace);

      }
    }

    if (event is AccountTransactionsLoad || event is AccountTransactionsDeleteEvent) {
      yield AccountTransactionsLoading();

      var transactions;

      try{
        transactions = await transactionsRepository.fetchAccountTransactions(accountId);
      }catch (e, trace) {
        log(e.toString(), error: e, stackTrace: trace);
        yield AccountTransactionsLoadingFailed();
      }

      if (transactions != null){
        yield AccountTransactionsUpdated(transactions: transactions, transactionDeleted: transactionDeleted);
      }

    }

  }}

