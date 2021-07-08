import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/fund_transactions/fund_transactions_events.dart';
import 'package:savings_app/blocs/fund_transactions/fund_transactions_states.dart';
import 'package:savings_app/models/transaction.dart';
import 'package:savings_app/repositories/accounts_repository.dart';
import 'package:savings_app/repositories/categories_repository.dart';
import 'package:savings_app/repositories/funds_repository.dart';
import 'package:savings_app/repositories/transactions_repository.dart';
import 'package:savings_app/repositories/user_repository.dart';

class FundTransactionsBloc
    extends Bloc<FundTransactionsEvent, FundTransactionsState> {
  String fundId;
  String authToken;
  int _lastLoadedPage = 0;
  List<Transaction> _cachedTransactions = [];
  TransactionsRepository _transactionsRepository;
  FundsRepository _fundsRepository;
  AccountsRepository _accountsRepository;
  CategoriesRepository _categoriesRepository;

  FundTransactionsBloc({@required this.fundId})
      : super(FundTransactionsInitialState()) {
    var authToken = UserRepository().restoreToken();
    _fundsRepository = FundsRepository(authToken: authToken);
    _accountsRepository = AccountsRepository(authToken: authToken);
    _transactionsRepository = TransactionsRepository(authToken: authToken);
    _categoriesRepository = CategoriesRepository(authToken: authToken);
  }

  @override
  Stream<FundTransactionsState> mapEventToState(
      FundTransactionsEvent event) async* {

    if (event is LoadNextPageEvent) {

      _lastLoadedPage++;

      if (_lastLoadedPage == 1){
        yield FundTransactionsLoadingState();
      }

      TransactionsPage transactionsPage;

      try {
        transactionsPage =
            await _transactionsRepository.fetchFundTransactions(fundId, _lastLoadedPage);
      } catch (e, trace) {
        log(e.toString(), error: e, stackTrace: trace);
        yield FundTransactionsLoadingFailed();
      }

      if (transactionsPage != null) {
        var accounts = _accountsRepository.restore();
        var funds = _fundsRepository.restore();
        var categories = _categoriesRepository.restore();

        _cachedTransactions.addAll(transactionsPage.items);

        yield FundTransactionsUpdatedState(
          hasNextPage: _lastLoadedPage < transactionsPage.totalPages,
            transactions: _cachedTransactions,
            fundsMap: {for (var fund in funds) fund.id: fund},
            accountsMap: {for (var account in accounts) account.id: account},
            categoriesMap: {for (var cat in categories) cat.id: cat});
      }
    }
  }
}
