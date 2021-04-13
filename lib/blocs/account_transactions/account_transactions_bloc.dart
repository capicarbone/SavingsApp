import 'dart:developer';

import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/account_transactions/account_transactions_events.dart';
import 'package:savings_app/blocs/account_transactions/account_transactions_state.dart';
import 'package:savings_app/repositories/accounts_repository.dart';
import 'package:savings_app/repositories/categories_repository.dart';
import 'package:savings_app/repositories/transactions_repository.dart';
import 'package:savings_app/repositories/user_repository.dart';

class AccountTransactionsBloc
    extends Bloc<AccountTransactionsEvent, AccountTransactionsState> {
  String accountId;

  TransactionsRepository _transactionsRepository;
  AccountsRepository _accountsRepository;
  CategoriesRepository _categoriesRepository;

  AccountTransactionsBloc({@required this.accountId})
      : super(AccountTransactionsInitial()) {
    var authToken = UserRepository().restoreToken();
    _accountsRepository = AccountsRepository(authToken: authToken);
    _transactionsRepository = TransactionsRepository(authToken: authToken);
    _categoriesRepository = CategoriesRepository(authToken: authToken);
  }

  @override
  Stream<AccountTransactionsState> mapEventToState(
      AccountTransactionsEvent event) async* {
    var transactionDeleted = false;

    if (event is AccountTransactionsDeleteEvent) {
      try {
        _transactionsRepository.delete(accountId, event.transactionId);
        transactionDeleted = true;
      } catch (e, trace) {
        log(e.toString(), error: e, stackTrace: trace);
      }
    }

    if (event is AccountTransactionsLoad ||
        event is AccountTransactionsDeleteEvent) {
      yield AccountTransactionsLoading();

      var transactions;

      try {
        transactions =
            await _transactionsRepository.fetchAccountTransactions(accountId);
      } catch (e, trace) {
        log(e.toString(), error: e, stackTrace: trace);
        yield AccountTransactionsLoadingFailed();
      }

      if (transactions != null) {
        var categoriesMap = _categoriesRepository.restore();
        var accountsMap = _accountsRepository.restore();

        yield AccountTransactionsUpdated(
            transactions: transactions,
            accountsMap: {for (var account in accountsMap) account.id: account},
            categoriesMap: {for (var cat in categoriesMap) cat.id: cat},
            transactionDeleted: transactionDeleted);
      }
    }
  }
}
