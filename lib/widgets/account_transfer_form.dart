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

  AccountTransferBloc _bloc;

  String accountFromId = null;

  String accountToId = null;

  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    _bloc = AccountTransferBloc(
        accounts: widget.accounts,
        transactionsRepository: widget.transactionsRepository);
  }

  void _clearForm() {
    setState(() {
      descriptionController.text = "";
      amountController.text = "";
      accountFromId = null;
      accountToId = null;
    });
  }

  void _submitForm() {
    var event = AccountTransferSubmitFormEvent(
        amount: amountController.text,
        description: descriptionController.text,
        accountFromId: accountFromId,
        accountToId: accountToId,
        accomplishedAt: _selectedDate);

    _bloc.add(event);
  }

  Widget _buildForm(AccountTransferState state) {
    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            controller: amountController,
            keyboardType: TextInputType.number,
            autovalidate: true,
            decoration: const InputDecoration(hintText: "Amount"),
            validator: (_) {
              if (state.errors != null) {
                return state.errors.amountErrorMessage;
              }

              return null;
            },
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
                    _selectedDate =
                    value != null ? value : _selectedDate;
                  }));
                },
              )
            ],
          ),
          DropdownButtonFormField(
            onChanged: (accountId) {
              accountFromId = accountId;
              var event = AccountTransferFromSelectedEvent(
                  accountFromId: accountId);
              _bloc.add(event);
            },
            decoration: const InputDecoration(hintText: "From"),
            autovalidate: true,
            validator: (_) {
              if (state.errors != null)
                return state.errors.accountFromMessage;
              return null;
            },
            value: accountFromId,
            items: [
              ...state.accountsFrom.map((e) => DropdownMenuItem(
                child: Text(e.name),
                value: e.id,
              ))
            ],
          ),
          DropdownButtonFormField(
            onChanged: (accountId) {
              accountToId = accountId;
            },
            value: accountToId,
            decoration: const InputDecoration(hintText: "To"),
            autovalidate: true,
            validator: (_) {
              if (state.errors != null)
                return state.errors.accountToMessage;
              return null;
            },
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
            onPressed: state.isSubmitting
                ? null
                : () {
              _submitForm();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        return _bloc;
      },
      child: BlocListener<AccountTransferBloc, AccountTransferState>(
        listener: (context, state) {
          if (state.successSubmit) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("Transfer saved"),
              backgroundColor: Colors.green,
            ));

            _clearForm();
          }

          if (state.errors != null && state.errors.submitError != null) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(state.errors.submitError),
              backgroundColor: Colors.red,
            ));
          }
        },
        child: BlocBuilder<AccountTransferBloc, AccountTransferState>(
            builder: (context, state) {
              // TODO: Potential error
          accountToId =
              state.accountsTo == null ? null : state.accountsTo[0].id;

          return _buildForm(state);
        }),
      ),
    );
  }
}
