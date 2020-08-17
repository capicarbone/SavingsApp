
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
import 'package:savings_app/models/transaction_post.dart';
import 'package:savings_app/repositories/transactions_repository.dart';
import 'dart:developer';

import 'in_out_form_states.dart';
import 'in_out_form_states.dart';

class InOutFormBloc extends Bloc<InOutFormEvent, InOutFormState> {

  TransactionsRepository transactionsRepository;

  InOutFormBloc({@required this.transactionsRepository}) : super(InOutFormInitialState());

  @override
  Stream<InOutFormState> mapEventToState(InOutFormEvent event) async* {

    if (event is InOutFormSubmitEvent) {

      yield InOutFormSubmittingState();

      var invalidState = _validateForm(event);

      if (invalidState != null){
        yield invalidState;
      }else {
        var transaction = _createTransactionPost(event);
        Response response;
        try {
          response = await transactionsRepository.postTransaction(
              transaction);
        }catch(e, trace) {
          yield InOutFormSubmitFailedState();
         log("InOutFormBlock", error: e, stackTrace: trace);
        }

        if (response != null){
          if (response.statusCode == 200){
            yield InOutFormSubmittedState();
          }else{
            yield InOutFormSubmitFailedState();
          }
        }


      }

    }

  }

  TransactionPost _createTransactionPost(InOutFormSubmitEvent event){

    var amount = double.parse(event.amount);

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

    if (event.accountId == null){
      errors.accountErrorMessage = "Required";
      return errors;
    }


    return null;
  }

}