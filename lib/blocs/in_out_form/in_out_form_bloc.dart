
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

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/in_out_form/in_out_form_events.dart';
import 'package:savings_app/blocs/in_out_form/in_out_form_states.dart';

class InOutFormBloc extends Bloc<InOutFormEvent, InOutFormState> {
  InOutFormBloc() : super(InOutFormInitialState());

  @override
  Stream<InOutFormState> mapEventToState(InOutFormEvent event) async* {

    if (event is InOutFormSubmitEvent) {

      // TODO: Submitting event
      var errors = _validateForm(event);

      if (errors != null){
        yield errors;
      }else {
        // TODO: Post to server
      }

    }

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