import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/account_transactions/account_transactions_bloc.dart';
import 'package:savings_app/blocs/account_transactions/account_transactions_events.dart';
import 'package:savings_app/blocs/account_transactions/account_transactions_state.dart';
import 'package:savings_app/models/account.dart';
import 'package:savings_app/repositories/accounts_repository.dart';
import 'package:savings_app/repositories/funds_repository.dart';
import 'package:savings_app/repositories/transactions_repository.dart';

class AccountTransactionsScreen extends StatelessWidget {
  static const routeName = '/transactions';

  Widget _buildAccountView(context) {
    return Center(
      child: Text("Transactions loaded"),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var args =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    Account account = args['account'];
    String authToken = args['authToken'];

    assert(authToken != null);
    assert(account != null);

    var fundsRepo = FundsRepository(authToken: authToken);
    var accountsRepo = AccountsRepository(authToken: authToken);
    var transactionsRepo = TransactionsRepository(
        authToken: authToken,
        accountsRepository: accountsRepo,
        fundsRepository: fundsRepo);

    var bloc = AccountTransactionsBloc(
        accountId: account.id, transactionsRepository: transactionsRepo);
    bloc.add(AccountTransactionsLoad());

    return Scaffold(
      appBar: AppBar(
        title: Text(account.name),
      ),
      body: BlocProvider(
        create: (_) {
          return bloc;
        },
        child: BlocBuilder<AccountTransactionsBloc, AccountTransactionsState>(
          builder: (ctx, state) {
            if (state is AccountTransactionsUpdated) {
              return _buildAccountView(context);
            }

            return _buildLoadingView();
          },
        ),
      ),
    );
  }
}
