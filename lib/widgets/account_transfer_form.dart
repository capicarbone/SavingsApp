import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/account_transfer/account_transfer_bloc.dart';
import 'package:savings_app/blocs/account_transfer/account_transfer_events.dart';
import 'package:savings_app/blocs/account_transfer/account_transfer_states.dart';
import 'package:savings_app/models/account.dart';
import 'package:savings_app/repositories/transactions_repository.dart';

class AccountTransferForm extends StatelessWidget {
  List<Account> accounts;
  TransactionsRepository transactionsRepository;

  AccountTransferForm({this.transactionsRepository, this.accounts});

  String fromAccountId = null;
  String toAccountsId = null;

  @override
  Widget build(BuildContext context) {
    var bloc = AccountTransferBloc(
        accounts: accounts, transactionsRepository: transactionsRepository);


    return BlocBuilder<AccountTransferBloc, AccountTransferState>(
        bloc: bloc,
        builder: (context, state) {
          return Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                DropdownButtonFormField(
                  onChanged: (accountId) {
                    fromAccountId = accountId;
                    toAccountsId = null;
                    var event = AccountTransferFromSelectedEvent(accountFromId: accountId);
                    bloc.add(event);
                  },
                  decoration: const InputDecoration(hintText: "From"),
                  autovalidate: true,
                  items: [
                    ...state.accountsFrom.map((e) => DropdownMenuItem(
                          child: Text(e.name),
                          value: e.id,
                        ))
                  ],
                ),
                DropdownButtonFormField(
                  onChanged: (accountId) {
                    toAccountsId = accountId;
                  },
                  value: state.accountsTo == null ? null : state.accountsTo[0].id,
                  decoration: const InputDecoration(hintText: "To"),
                  autovalidate: true,
                  items: state.accountsTo == null ? null : [
                    ...state.accountsTo.map((e) => DropdownMenuItem(
                          child: Text(e.name),
                          value: e.id,
                        ))
                  ],
                ),
                RaisedButton(
                  child: Text("Save"),
                  onPressed: () {},
                )
              ],
            ),
          );
        });
  }
}
