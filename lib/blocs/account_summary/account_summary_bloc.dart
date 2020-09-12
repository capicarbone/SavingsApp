
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/account_summary/account_summary_event.dart';
import 'package:savings_app/blocs/account_summary/account_summary_state.dart';

class AccountSummaryBloc extends Bloc<AccountSummaryEvent, AccountSummaryState>{

  AccountSummaryBloc(double balance): super(AccountSummaryInitialState(balance));

  @override
  AccountSummaryState get state => super.state;

  @override
  Stream<AccountSummaryState> mapEventToState(AccountSummaryEvent event) async* {

    if (event is AccountSummaryBalanceUpdateEvent) {
      var newBalance = state.balance - event.change;

      yield AccountSummaryBalanceUpdated(newBalance);
    }

  }

}