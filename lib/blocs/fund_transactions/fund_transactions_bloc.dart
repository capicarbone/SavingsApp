
import 'package:flutter/cupertino.dart';
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

      await Future.delayed(Duration(seconds: 1));

      yield FundTransactionsUpdatedState(transactions: null);
    }
  }

}