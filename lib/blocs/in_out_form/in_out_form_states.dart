
class InOutFormState {
}

class InOutFormInitialState extends InOutFormState {}

class InOutFormInvalidState extends InOutFormState {
  String amountErrorMessage;
  String accountErrorMessage;
  String categoryErrorMessage;
  String descriptionErrorMessage;
}

class InOutFormSubmittingState extends InOutFormState {}

class InOutFormSubmittedState extends InOutFormState {}

class InOutFormSubmitFailedState extends InOutFormState {}
