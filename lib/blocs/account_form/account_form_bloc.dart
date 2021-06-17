import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/account_form/account_form_events.dart';
import 'package:savings_app/blocs/account_form/account_form_states.dart';
import 'package:savings_app/models/account.dart';
import 'package:savings_app/repositories/accounts_repository.dart';
import 'package:savings_app/repositories/user_repository.dart';

class AccountFormBloc extends Bloc<AccountFormEvent, AccountFormState> {
  AccountsRepository repository;

  AccountFormBloc() : super(FormReadyState()) {
    var authToken = UserRepository().restoreToken();
    repository = AccountsRepository(authToken: authToken);
  }

  @override
  Stream<AccountFormState> mapEventToState(AccountFormEvent event) async* {
    if (event is SubmitEvent) {
      yield FormSubmittingState();

      if (event.name.isEmpty) {
        yield FormSubmitFailedState();
        return;
      }

      final double initialBalance = (event.initialBalance == 0) ? double.parse(event.initialBalance) : 0;

      await repository.save(
          name: event.name, initialBalance: initialBalance);

      yield FormSubmittedState();
    }
  }
}
