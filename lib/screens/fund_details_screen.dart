
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/fund_transactions/fund_transactions_bloc.dart';
import 'package:savings_app/blocs/fund_transactions/fund_transactions_events.dart';
import 'package:savings_app/blocs/fund_transactions/fund_transactions_states.dart';
import 'package:savings_app/models/fund.dart';
import 'package:savings_app/repositories/accounts_repository.dart';
import 'package:savings_app/repositories/funds_repository.dart';
import 'package:savings_app/repositories/transactions_repository.dart';

class FundDetailsScreen extends StatelessWidget {
  static const routeName = '/fund-details';

  FundTransactionsBloc _bloc;

  Widget _buildLoadingView() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildFundSummay(Fund fund){
    return Container(
      width: double.infinity,
      color: Colors.blueGrey,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              "Balance",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "\$${fund.balance}",
              style: TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFundTransactionsList(Fund fund) {
    return Container(
      child: BlocBuilder<FundTransactionsBloc, FundTransactionsState >(
        builder: (ctx, state) {
          if (state is FundTransactionsUpdatedState) {
            return Text("Funds list");
          }

          return _buildLoadingView();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    Fund fund = args['fund'];
    String authToken = args['authToken'];

    var fundsRepo = FundsRepository(authToken: authToken);
    var accountsRepo = AccountsRepository(authToken: authToken);
    var transactionsRepo = TransactionsRepository(
        authToken: authToken,
        accountsRepository: accountsRepo,
        fundsRepository: fundsRepo);


    if (_bloc == null){
      _bloc = FundTransactionsBloc(
          fundId: fund.id,
          transactionsRepository: transactionsRepo
      );
    }


    return Scaffold(
      appBar: AppBar(
        title: Text(fund.name),
      ),
      body: BlocProvider(
        create: (_) {
          _bloc.add(FundTransactionsLoadEvent());
          return _bloc;
        },
        child: Column(children: <Widget>[
          _buildFundSummay(fund),
          Flexible(child: _buildFundTransactionsList(fund),)
        ],),
      ),
    );
  }
}
