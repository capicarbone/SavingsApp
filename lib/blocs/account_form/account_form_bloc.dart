

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/account_form/account_form_events.dart';
import 'package:savings_app/blocs/account_form/account_form_states.dart';
import 'package:savings_app/repositories/accounts_repository.dart';

class AccountFormBloc extends Bloc<AccountFormEvent, AccountFormState> {

  AccountsRepository repository;

  AccountFormBloc(String authToken) :
        repository = AccountsRepository(authToken: authToken),
        super(FormReadyState());

  @override
  Stream<AccountFormState> mapEventToState(AccountFormEvent event) async* {

    if (event is SubmitEvent) {
      yield FormSubmittingState();

      yield FormSubmittedState();
    }

  }


}