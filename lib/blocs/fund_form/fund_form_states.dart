enum FundFormError {
  missingName,
  missingAssignment,
  invalidAssignment,
  overassignment,
  invalidMinimum,
  invalidLimit,
  serverError
}

class FundFormState {
  double availableAssignment = 0;

  FundFormState({this.availableAssignment});
}

class FormReadyState extends FundFormState {

  FormReadyState({double availableForAssignment})
      : super(availableAssignment: availableForAssignment);
}

class SubmittingState extends FundFormState {
  SubmittingState({double availableAssignment})
      : super(availableAssignment: availableAssignment);
}

class SubmittedState extends FundFormState {
  SubmittedState({double availableAssignment})
      : super(availableAssignment: availableAssignment);
}

class SubmitFailedState extends FundFormState {
  FundFormError error;

  SubmitFailedState({double availableAssignment, this.error})
      : super(availableAssignment: availableAssignment);
}
