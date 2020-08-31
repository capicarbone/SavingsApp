
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/account_transactions/account_transactions_bloc.dart';
import 'package:savings_app/blocs/account_transactions/account_transactions_events.dart';
import 'package:savings_app/blocs/account_transactions/account_transactions_state.dart';
import 'package:savings_app/models/account.dart';

class AccountTransactionsScreen extends StatelessWidget {

  static const routeName = '/transactions';

  Widget _buildAccountView(context){
    return Center(
      child: Text("Transactions loaded"),
    );
  }

  Widget _buildLoadingView(){
    return Center(
      child: CircularProgressIndicator(),
    );
  }


  @override
  Widget build(BuildContext context) {

    var args = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    Account account = args['account'];

    var bloc = AccountTransactionsBloc(accountId: account.id);
    bloc.add(AccountTransactionsLoad());

    return Scaffold(
      appBar: AppBar(title: Text(account.name),),
      body: BlocProvider(
        create: (_){
          return bloc;
        } ,
        child: BlocBuilder<AccountTransactionsBloc, AccountTransactionsState>(
          builder: (ctx, state){
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
