import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/account_transfer/account_transfer_events.dart';
import 'package:savings_app/blocs/account_transfer/account_transfer_states.dart';
import 'package:savings_app/models/account.dart';
import 'package:savings_app/repositories/transactions_repository.dart';

class AccountTransferBloc
    extends Bloc<AccountTransferEvent, AccountTransferState> {
  TransactionsRepository transactionsRepository;
  List<Account> accounts;

  AccountTransferBloc({this.transactionsRepository, this.accounts})
      : super(AccountTransferState.initial(accounts));

  @override
  Stream<AccountTransferState> mapEventToState(
      AccountTransferEvent event) async* {
    if (event is AccountTransferFromSelectedEvent) {
      yield AccountTransferState.withAccountsTo(accounts, null);
      //var toAccounts = [];
      var toAccounts = accounts
          .where((element) => element.id != event.accountFromId)
          .toList();
      yield AccountTransferState.withAccountsTo(accounts, toAccounts);
    }
  }
}
