import 'package:flutter_bloc/flutter_bloc.dart';
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
      yield state.copyWith(isSubmitting: true);

      var errors = _validateForm(event);

      if (errors != null) {
        yield state.copyWith(errors: errors);
      }else {
        var transaction = _createTransferPost(event);

        var response = await transactionsRepository.postAccountTransfer(transaction);
      }

      yield state.copyWith(isSubmitting: false);
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

    if (!_existsField(event.accountFromId)) {
      errors.accountFromMessage = "Required";
      return errors;
    }

    if (!_existsField(event.accountToId)) {
      errors.accountToMessage = "Required";
      return errors;
    }

    return null;
  }

}
