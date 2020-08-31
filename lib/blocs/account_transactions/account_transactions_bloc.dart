
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/account_transactions/account_transactions_events.dart';
import 'package:savings_app/blocs/account_transactions/account_transactions_state.dart';

class AccountTransactionsBloc extends Bloc<AccountTransactionsEvent, AccountTransactionsState>{

  String accountId;

  AccountTransactionsBloc({this.accountId}) : super(AccountTransactionsInitial());


  @override
  Stream<AccountTransactionsState> mapEventToState(AccountTransactionsEvent event) async* {

    if (event is AccountTransactionsLoad) {
      yield AccountTransactionsLoading();

      await Future.delayed(Duration(seconds: 1));

      yield AccountTransactionsUpdated(transactions: null);

    }

  }}

