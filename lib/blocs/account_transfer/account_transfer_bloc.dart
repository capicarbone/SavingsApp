import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:savings_app/blocs/account_transfer/account_transfer_events.dart';
import 'package:savings_app/blocs/account_transfer/account_transfer_states.dart';
import 'package:savings_app/models/account.dart';
import 'package:savings_app/models/account_transfer_post.dart';
import 'package:savings_app/models/transaction_post.dart';
import 'package:savings_app/repositories/transactions_repository.dart';

class AccountTransferBloc
    extends Bloc<AccountTransferEvent, AccountTransferState> {
  TransactionsRepository transactionsRepository;
  List<Account> accounts;

  AccountTransferBloc({this.transactionsRepository, this.accounts}) : super(AccountTransferState.initial(accounts));


  @override
  AccountTransferState get state => super.state;

  @override
  Stream<AccountTransferState> mapEventToState(
      AccountTransferEvent event) async* {
    if (event is AccountTransferFromSelectedEvent) {
      //var toAccounts = [];
      var toAccounts = accounts
          .where((element) => element.id != event.accountFromId)
          .toList();
      yield state.copyWith(accountsTo: toAccounts);
    }

    if (event is AccountTransferSubmitFormEvent) {
      yield state.copyWith(isSubmitting: true, errors: null);

      var errors = _validateForm(event);

      if (errors != null) {
        yield state.copyWith(errors: errors);
      }else {
        Response response;
        var transaction = _createTransferPost(event);

        try {
          response = await transactionsRepository.postAccountTransfer(transaction);
        }catch (e, trace) {
          log("AccountTransferBloc", error: e, stackTrace: trace);
        }

        if (response != null && response.statusCode == 200){
          yield state.copyWith(successSubmit: true, isSubmitting: false);
          yield AccountTransferState.initial(accounts);
        }else{
          // TODO: Take error from response if exists
          var errors = AccountTransferFormErrors(submitError: "Error submitting form.");
          yield state.copyWith(isSubmitting: false, errors: errors);
        }
      }

    }
  }

  AccountTransferPost _createTransferPost(AccountTransferSubmitFormEvent event){

    var amount = double.parse(event.amount);

    return AccountTransferPost( amount: amount, dateAccomplished: event.accomplishedAt,
    accountToId: event.accountToId, accountFromId: event.accountFromId);

  }

  bool _existsField(String value) {
    return !(value == null || value.isEmpty);
  }

  AccountTransferFormErrors _validateForm(AccountTransferSubmitFormEvent event){

    var errors = AccountTransferFormErrors();

    if (!_existsField(event.amount)) {
      errors.amountErrorMessage = "Required";
      return errors;
    }

    var amount = double.parse(event.amount);

    if (amount <= 0.0) {
      errors.amountErrorMessage = "Invalid value";
      return errors;
    }

    if (!_existsField(event.accountFromId)) {
      errors.accountFromMessage = "Required";
      return errors;
    }

    // TODO: Validate that accountFrom belongs to accounts

    if (!_existsField(event.accountToId)) {
      errors.accountToMessage = "Required";
      return errors;
    }

    // TODO: Validate that accountTo belongs to accounts

    // TODO: Validate accountTo and accountFrom are different

    return null;
  }

}
