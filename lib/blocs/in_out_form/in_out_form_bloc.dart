
// States
// InOutFormInitialState
// InOutFormInvalidState
// InOutFormSubmittingState
// -- amount
// -- acount
// -- category
// InOutFormSubmittedState
// InOutFormSubmitFailedState

// Events
// InOutFormSubmitEvent
// InOutFormFieldsUpdatedEvent

import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/in_out_form/in_out_form_events.dart';
import 'package:savings_app/blocs/in_out_form/in_out_form_states.dart';
import 'package:savings_app/models/transaction.dart';
import 'package:savings_app/models/transaction_post.dart';
import 'package:savings_app/repositories/accounts_repository.dart';
import 'package:savings_app/repositories/funds_repository.dart';
import 'package:savings_app/repositories/transactions_repository.dart';
import 'dart:developer';

import 'in_out_form_states.dart';
import 'in_out_form_states.dart';

class InOutFormBloc extends Bloc<InOutFormEvent, InOutFormState> {

  TransactionsRepository transactionsRepository;
  AccountsRepository accountsRepository;
  FundsRepository fundsRepository;

  bool expenseMode = false;

  InOutFormBloc({@required this.transactionsRepository,
    @required this.fundsRepository,
    @required this.accountsRepository,
    this.expenseMode: false}) : super(InOutFormInitialState());

  @override
  Stream<InOutFormState> mapEventToState(InOutFormEvent event) async* {

    if (event is InOutFormSubmitEvent) {

      yield InOutFormSubmittingState();

      var invalidState = _validateForm(event);

      if (invalidState != null){
        yield invalidState;
      }else {


        try {
          var transactionPost = _createTransactionPost(event);


          var transaction = await transactionsRepository.postTransaction(
              transactionPost);

          // TODO: Update balances
          _updateBalances(transaction);

          yield InOutFormSubmittedState();

        }catch(e, trace) {
          yield InOutFormSubmitFailedState();
         log("InOutFormBlock", error: e, stackTrace: trace);
        }

      }

    }

  }

  void _updateBalances(Transaction transaction) {
    transaction.accountTransactions.forEach((element) {
      accountsRepository.updateBalance(element.accountId, element.change);
    });

    transaction.fundTransactions.forEach((element) {
      fundsRepository.updateBalance(element.fundId, element.change);
    });
  }

  TransactionPost _createTransactionPost(InOutFormSubmitEvent event){

    var amount = double.parse(event.amount);

    amount = expenseMode ? -amount : amount;

    return TransactionPost(amount: amount, accomplishedAt: event.accomplishedAt,
    accountId: event.accountId, categoryId: event.categoryId,
    description: event.description);

  }

  InOutFormInvalidState _validateForm(InOutFormSubmitEvent event){

    var errors = InOutFormInvalidState();

    if (event.amount == null || event.amount.isEmpty) {
      errors.amountErrorMessage = "Required";
      return errors;
    }

    var amount = 0.0;

    try {
      amount = double.parse(event.amount);
    }catch(e) {
      errors.amountErrorMessage = "Not a number.";
      return errors;
    }

    if (amount == 0) {
      errors.amountErrorMessage = "Must be different than 0.";
      return errors;
    }

    if (amount < 0) {
      errors.amountErrorMessage = "Invalid value";
    }

    if (event.accountId == null){
      errors.accountErrorMessage = "Required";
      return errors;
    }


    return null;
  }

}