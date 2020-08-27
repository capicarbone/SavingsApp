import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/account_transfer/account_transfer_events.dart';
import 'package:savings_app/blocs/account_transfer/account_transfer_states.dart';
import 'package:savings_app/models/account.dart';
import 'package:savings_app/repositories/transactions_repository.dart';

class AccountTransferBloc
    extends Bloc<AccountTransferEvent, AccountTransferState> {
  TransactionsRepository transactionsRepository;
  List<Account> accounts;
  AccountTransferState state;

  AccountTransferBloc({this.transactionsRepository, this.accounts})
      : super(AccountTransferState.initial(accounts));

  @override
  Stream<AccountTransferState> mapEventToState(
      AccountTransferEvent event) async* {
    if (event is AccountTransferFromSelectedEvent) {
      //var toAccounts = [];
      var toAccounts = accounts
          .where((element) => element.id != event.accountFromId)
          .toList();
      state = AccountTransferState.withAccountsTo(accounts, toAccounts);
      yield state;
    }

    if (event is AccountTransferSubmitFormEvent) {

    }
  }
}
