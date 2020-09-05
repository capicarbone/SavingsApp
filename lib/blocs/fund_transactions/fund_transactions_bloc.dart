
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/fund_transactions/fund_transactions_events.dart';
import 'package:savings_app/blocs/fund_transactions/fund_transactions_states.dart';
import 'package:savings_app/repositories/transactions_repository.dart';

class FundTransactionsBloc extends Bloc<FundTransactionsEvent, FundTransactionsState> {

  String fundId;
  TransactionsRepository transactionsRepository;

  FundTransactionsBloc({@required this.fundId, @required this.transactionsRepository}) : super(FundTransactionsInitialState());

  @override
  Stream<FundTransactionsState> mapEventToState(FundTransactionsEvent event) async* {
    if (event is FundTransactionsLoadEvent) {
      yield FundTransactionsLoadingState();

      var transactions;

      try{
        transactions = await transactionsRepository.getFundTransactions(fundId);
      }catch(e, trace) {
        log(e.toString(), error: e, stackTrace: trace);
        yield FundTransactionsLoadingFailed();
      }

      if (transactions != null){
        yield FundTransactionsUpdatedState(transactions: transactions);
      }


    }
  }

}