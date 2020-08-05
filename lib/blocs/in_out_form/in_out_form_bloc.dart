
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
      var errors = _validateForm(event);

      if (errors != null){
        yield errors;
      }

    }

  }

  InOutFormInvalidState _validateForm(InOutFormSubmitEvent event){

    var errors = InOutFormInvalidState();

    if (event.amount == null || event.amount.isEmpty) {
      errors.amountErrorMessage = "Required";
      return errors;
    }

    return null;
  }

}