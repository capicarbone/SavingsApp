
class InOutFormState {
}

class InOutFormInitialState extends InOutFormState {}

class InOutFormInvalidState extends InOutFormState {
  String amountErrorMessage;
  String accountErrorMessage;
  String categoryErrorMessage;
  String descriptionErrorMessage;

  get hasAmountError => amountErrorMessage != null;
  get hasAccountError => accountErrorMessage != null;

}

class InOutFormSubmittingState extends InOutFormState {}

class InOutFormSubmittedState extends InOutFormState {}

class InOutFormSubmitFailedState extends InOutFormState {}
