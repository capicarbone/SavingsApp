import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/account_transfer/account_transfer_bloc.dart';
import 'package:savings_app/blocs/account_transfer/account_transfer_events.dart';
import 'package:savings_app/blocs/account_transfer/account_transfer_states.dart';
import 'package:savings_app/models/account.dart';
import 'package:savings_app/repositories/transactions_repository.dart';

class AccountTransferForm extends StatefulWidget {
  List<Account> accounts;
  TransactionsRepository transactionsRepository;

  AccountTransferForm({this.transactionsRepository, this.accounts});

  @override
  _AccountTransferFormState createState() => _AccountTransferFormState();
}

class _AccountTransferFormState extends State<AccountTransferForm> {
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();

  String fromAccountId = null;

  String toAccountsId = null;

  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var bloc = AccountTransferBloc(
        accounts: widget.accounts, transactionsRepository: widget.transactionsRepository);

    return BlocBuilder<AccountTransferBloc, AccountTransferState>(
        bloc: bloc,
        builder: (context, state) {
          return Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  autovalidate: true,
                  decoration: const InputDecoration(hintText: "Amount"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Text(DateFormat.yMd().format(_selectedDate)),
                    ),
                    RaisedButton(
                      child: Text("Pick a date"),
                      onPressed: () {
                        var now = DateTime.now();
                        showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime(now.year - 1, 1, 1),
                            lastDate: DateTime(now.year + 1, 1, 1))
                        .then((value) => setState(() {
                          _selectedDate = value != null ? value : _selectedDate;
                        }));
                      },
                    )
                  ],
                ),
                DropdownButtonFormField(
                  onChanged: (accountId) {
                    fromAccountId = accountId;
                    toAccountsId = null;
                    var event = AccountTransferFromSelectedEvent(
                        accountFromId: accountId);
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
                  value:
                      state.accountsTo == null ? null : state.accountsTo[0].id,
                  decoration: const InputDecoration(hintText: "To"),
                  autovalidate: true,
                  items: state.accountsTo == null
                      ? null
                      : [
                          ...state.accountsTo.map((e) => DropdownMenuItem(
                                child: Text(e.name),
                                value: e.id,
                              ))
                        ],
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(hintText: "Description"),
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
