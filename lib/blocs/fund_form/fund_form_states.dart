
enum FundFormError {
  missingName,
  missingAssignment,
  invalidAssignment,
  overassignment,
  invalidMinimum,
  invalidLimit,
  serverError
}

class FundFormState {}

class FormReadyState extends FundFormState {}

class SubmittingState extends FundFormState {}

class SubmittedState extends FundFormState {}

class SubmitFailedState extends FundFormState {
  FundFormError error;

  SubmitFailedState({this.error});
}

